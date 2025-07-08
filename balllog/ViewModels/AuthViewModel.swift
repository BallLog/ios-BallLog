//
//  AuthViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import Foundation
import Combine
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import AuthenticationServices

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoggedIn = false
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let authService: AuthServiceProtocol
    private let tokenManager: TokenManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService(), tokenManager: TokenManager = TokenManager.shared) {
        self.authService = authService
        self.tokenManager = tokenManager
    }
    
    // MARK: - Public Methods
    func handleKakaoLogin() {
        print("=== 카카오 로그인 시작 ===")
        isLoading = true
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                Task { @MainActor in
                    self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                Task { @MainActor in
                    self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
                }
            }
        }
    }
    
    func handleAppleLoginSuccess(userData: AppleLoginModel) {
        print("=== 애플 로그인 성공 처리 ===")
        
        let appleUser = User(
            id: userData.userId,
            email: userData.email,
            name: "\(userData.fullName?.givenName ?? "") \(userData.fullName?.familyName ?? "")".trimmingCharacters(in: .whitespaces),
            loginType: .apple
        )
        
        handleLoginSuccess(user: appleUser)
    }
    
    func checkAutoLogin() {
        print("=== 자동 로그인 확인 ===")
        
        if tokenManager.isTokenValid() {
            print("✅ 유효한 토큰 발견 - 자동 로그인 처리")
            isLoggedIn = true
        } else {
            print("❌ 유효한 토큰 없음")
        }
    }
    
    func logout() async {
        print("=== 로그아웃 처리 ===")
        tokenManager.clearTokens()
        
        user = nil
        isLoggedIn = false
        
        print("✅ 로그아웃 완료")
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        defer { isLoading = false }
        
        if let error = error {
            print("❌ 카카오 로그인 실패: \(error)")
            handleError(error)
            return
        }
        
        guard let token = oauthToken else {
            print("❌ 카카오 토큰이 없음")
            handleError(AuthError.invalidResponse)
            return
        }
        
        print("✅ 카카오 토큰 획득 성공")
        
        UserApi.shared.me { [weak self] (kakaoUser, error) in
            Task { @MainActor in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ 카카오 사용자 정보 조회 실패: \(error)")
                    self.handleError(error)
                    return
                }
                
                guard let kakaoUser = kakaoUser else {
                    print("❌ 카카오 사용자 정보가 없음")
                    self.handleError(AuthError.invalidResponse)
                    return
                }
                
                print("✅ 카카오 사용자 정보 조회 성공")
                
                do {
                    let response = try await self.authService.kakaoLogin(accessToken: token.accessToken)
                    
                    if response.code == "OK", let loginData = response.data {
                        print("✅ 서버 로그인 성공")
                        
                        // 토큰 저장
                        self.tokenManager.saveUserTokens(
                            accessToken: loginData.tokenInfo.accessToken,
                            refreshToken: loginData.tokenInfo.refreshToken
                        )
                        
                        self.tokenManager.saveTokenExpirationTimes(
                            accessTokenExpiry: loginData.tokenInfo.accessTokenExpiresIn,
                            refreshTokenExpiry: loginData.tokenInfo.refreshTokenExpiresIn
                        )
                        
                        // 사용자 정보 생성
                        let socialUser = User(
                            id: String(kakaoUser.id!),
                            email: kakaoUser.kakaoAccount?.email,
                            name: kakaoUser.kakaoAccount?.profile?.nickname,
                            loginType: .kakao
                        )
                        
                        self.handleLoginSuccess(user: socialUser)
                        
                    } else {
                        print("❌ 서버 로그인 실패: \(response.message)")
                        self.handleError(AuthError.serverError(0))
                    }
                    
                } catch {
                    print("❌ 서버 로그인 API 오류: \(error)")
                    self.handleError(error)
                }
            }
        }
    }
    
    private func handleLoginSuccess(user: User) {
        print("✅ 로그인 성공: \(user.name ?? "Unknown")")
        
        self.isLoading = false
        self.user = user
        self.isLoggedIn = true
        self.errorMessage = nil
    }
    
    private func handleError(_ error: Error) {
        print("❌ 오류 처리: \(error)")
        
        self.isLoading = false
        self.errorMessage = error.localizedDescription
    }
    
    private func refreshToken() async {
        guard tokenManager.getRefreshToken() != nil else {
            await logout()
            return
        }
        
        // TODO: 리프레시 토큰 API 구현
        await logout() // 임시로 로그아웃 처리
    }
}
