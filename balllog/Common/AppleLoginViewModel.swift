//
//  AppleLoginBtnVM.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
//

import AuthenticationServices
import Combine

class AppleLoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    @Published var loginSuccess: Bool = false
    @Published var userData: AppleLoginModel?
    
    func handleAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
    }
    
    func handleAppleSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        self.isLoading = true
        
        switch result {
        case .success(let authorization):
            handleAuthorizationSuccess(authorization)
        case .failure(let error):
            handleAuthorizationFailure(error)
        }
        
        self.isLoading = false
    }
    
    private func handleAuthorizationSuccess(_ authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            let model = AppleLoginModel(
                userId: appleIdCredential.user,
                email: appleIdCredential.email,
                fullName: appleIdCredential.fullName,
                identityToken: appleIdCredential.identityToken,
                authorizationCode: appleIdCredential.authorizationCode
            )
            
            userData = model
            self.loginSuccess = true
            
            // 로그 출력
            printUserInfo(model)
            
        case let passwordCredential as ASPasswordCredential:
            // iCloud Keychain 사용자 처리
            print("암호 기반 인증에 성공하였습니다.")
            print("사용자 이름: \(passwordCredential.user)")
            print("비밀번호: \(passwordCredential.password)")
            
        default:
            break
        }
    }
    
    private func handleAuthorizationFailure(_ error: Error) {
        self.error = error
        self.loginSuccess = false
        print("로그인 실패", error.localizedDescription)
    }
    
    private func printUserInfo(_ model: AppleLoginModel) {
        print("Apple ID 로그인에 성공하였습니다. : \(loginSuccess)")
        print("사용자 ID: \(model.userId)")
        print("전체 이름: \(model.fullName?.givenName ?? "") \(model.fullName?.familyName ?? "")")
        print("이메일: \(model.email ?? "")")
        if let token = model.identityToken {
            print("Token: \(String(data: token, encoding: .utf8) ?? "")")
        }
        if let code = model.authorizationCode {
            print("authorizationCode: \(String(data: code, encoding: .utf8) ?? "")")
        }
    }
}
