//
//  AppleLoginBtnVM.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
//
import AuthenticationServices
import Combine

@MainActor
class AppleLoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    @Published var loginSuccess: Bool = false
    @Published var userData: AppleLoginModel?
    
    func handleAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName] // fullName도 추가
    }
    
    func handleAppleSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        self.isLoading = true
        
        switch result {
        case .success(let authorization):
            handleAuthorizationSuccess(authorization)
        case .failure(let error):
            handleAuthorizationFailure(error)
        }
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
            printUserInfo(model)
            
            // 백엔드 서버로 Apple 로그인 요청
            sendAppleLoginToBackend(model)
            
        case let passwordCredential as ASPasswordCredential:
            // iCloud Keychain 사용자 처리
            print("암호 기반 인증에 성공하였습니다.")
            print("사용자 이름: \(passwordCredential.user)")
            self.isLoading = false
            
        default:
            self.isLoading = false
            break
        }
    }
    
    private func handleAuthorizationFailure(_ error: Error) {
        self.error = error
        self.loginSuccess = false
        self.isLoading = false
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
    
    // 백엔드 서버로 Apple 로그인 정보 전송
    private func sendAppleLoginToBackend(_ model: AppleLoginModel) {
        guard let identityToken = model.identityTokenString else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Identity Token이 없습니다."])
            handleAuthorizationFailure(error)
            return
        }
        
        Task {
            do {
                print("🍎 Sending Apple login to backend...")
                
                let response = try await APIUtils.shared.appleLogin(
                    identityToken: identityToken,
                    authorizationCode: model.authorizationCodeString,
                    email: model.email,
                    fullName: model.fullName
                )
                
                if response.code == "OK", let loginData = response.data {
                    print("✅ Apple 백엔드 로그인 성공!")
                    
                    // 서버에서 받은 토큰 저장
                    TokenManager.shared.saveUserTokens(
                        accessToken: loginData.tokenInfo.accessToken,
                        refreshToken: loginData.tokenInfo.refreshToken
                    )
                    
                    
                    // 토큰 만료 시간도 저장
                    TokenManager.shared.saveTokenExpirationTimes(
                        accessTokenExpiry: loginData.tokenInfo.accessTokenExpiresIn,
                        refreshTokenExpiry: loginData.tokenInfo.refreshTokenExpiresIn
                    )
                    
                    await MainActor.run {
                        self.loginSuccess = true
                        self.isLoading = false
                        print("🎉 Apple 로그인 및 백엔드 연동 완료!")
                    }
                    
                } else {
                    await MainActor.run {
                        let errorMessage = response.message
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        self.handleAuthorizationFailure(error)
                    }
                }
                
            } catch {
                await MainActor.run {
                    print("❌ Apple 백엔드 로그인 실패: \(error)")
                    self.handleAuthorizationFailure(error)
                }
            }
        }
    }
    
    private func printUserInfo(_ model: AppleLoginModel) {
        print("🍎 Apple ID 로그인 정보:")
        print("  - 사용자 ID: \(model.userId)")
        print("  - 이름: \(model.fullName?.givenName ?? "") \(model.fullName?.familyName ?? "")")
        print("  - 이메일: \(model.email ?? "N/A")")
        print("  - Identity Token: \(model.identityTokenString?.prefix(50) ?? "N/A")...")
        print("  - Authorization Code: \(model.authorizationCodeString?.prefix(50) ?? "N/A")...")
    }
}
