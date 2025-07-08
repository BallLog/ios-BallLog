//
//  AppleLoginViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import Foundation
import AuthenticationServices
import Combine

@MainActor
class AppleLoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var error: Error?
    @Published var loginSuccess: Bool = false
    @Published var userData: AppleLoginModel?
    
    // MARK: - Private Properties
    private let authService: AuthServiceProtocol
    private let tokenManager: TokenManager
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService(), tokenManager: TokenManager = TokenManager.shared) {
        self.authService = authService
        self.tokenManager = tokenManager
    }
    
    // MARK: - Public Methods
    func handleAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        print("🍎 애플 로그인 요청 설정")
        request.requestedScopes = [.email, .fullName]
    }
    
    func handleAppleSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        print("=== 애플 로그인 완료 처리 ===")
        isLoading = true
        
        switch result {
        case .success(let authorization):
            handleAuthorizationSuccess(authorization)
        case .failure(let error):
            handleAuthorizationFailure(error)
        }
    }
    
    func clearError() {
        error = nil
    }
    
    // MARK: - Private Methods
    private func handleAuthorizationSuccess(_ authorization: ASAuthorization) {
        print("✅ 애플 인증 성공")
        
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
            sendAppleLoginToBackend(model)
            
        case let passwordCredential as ASPasswordCredential:
            print("🔑 패스워드 기반 인증 성공")
            print("사용자 이름: \(passwordCredential.user)")
            isLoading = false
            
        default:
            print("❌ 알 수 없는 인증 방식")
            isLoading = false
        }
    }
    
    private func handleAuthorizationFailure(_ error: Error) {
        print("❌ 애플 로그인 실패: \(error)")
        
        self.error = error
        self.loginSuccess = false
        self.isLoading = false
    }
    
    private func sendAppleLoginToBackend(_ model: AppleLoginModel) {
        print("=== 애플 로그인 서버 전송 ===")
        
        guard let identityToken = model.identityTokenString else {
            let error = AuthError.invalidResponse
            handleAuthorizationFailure(error)
            return
        }
        
        Task {
            do {
                let response = try await authService.appleLogin(
                    identityToken: identityToken,
                    authorizationCode: model.authorizationCodeString,
                    email: model.email,
                    fullName: model.fullName
                )
                
                if response.code == "OK", let loginData = response.data {
                    print("✅ 애플 서버 로그인 성공")
                    
                    // 토큰 저장
                    tokenManager.saveUserTokens(
                        accessToken: loginData.tokenInfo.accessToken,
                        refreshToken: loginData.tokenInfo.refreshToken
                    )
                    
                    tokenManager.saveTokenExpirationTimes(
                        accessTokenExpiry: loginData.tokenInfo.accessTokenExpiresIn,
                        refreshTokenExpiry: loginData.tokenInfo.refreshTokenExpiresIn
                    )
                    
                    loginSuccess = true
                    isLoading = false
                    
                } else {
                    print("❌ 애플 서버 로그인 실패: \(response.message)")
                    let error = AuthError.serverError(0)
                    handleAuthorizationFailure(error)
                }
                
            } catch {
                print("❌ 애플 서버 로그인 API 오류: \(error)")
                handleAuthorizationFailure(error)
            }
        }
    }
    
    private func printUserInfo(_ model: AppleLoginModel) {
        print("🍎 애플 사용자 정보:")
        print("  - 사용자 ID: \(model.userId)")
        print("  - 이름: \(model.fullName?.givenName ?? "") \(model.fullName?.familyName ?? "")")
        print("  - 이메일: \(model.email ?? "N/A")")
        print("  - Identity Token: \(model.identityTokenString?.prefix(50) ?? "N/A")...")
    }
}
