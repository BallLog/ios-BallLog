//
//  AuthViewModel.swift
//  balllog
//
//  Created by 전은혜 on 10/28/24.
//

import Foundation
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct User: Codable {
    let id: String
    let email: String?
    let name: String?
    let loginType: LoginType
}

enum LoginType: String, Codable {
    case apple
    case kakao
    case none
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // 카카오 로그인 (토큰 획득)
    func handleKakaoLogin() {
        isLoading = true
        
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 앱 로그인 인증
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                Task { @MainActor in
                    self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
                }
            }
        } else {
            // 미설치 시 카카오 계정 로그인
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                Task { @MainActor in
                    self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
                }
            }
        }
    }
    
    func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        defer { isLoading = false }

        if let error = error {
            handleError(error)
            return
        }
        
        guard let token = oauthToken else {
            handleError(APIError.invalidResponse)
            return
        }
        
        UserApi.shared.me { [weak self] (kakaoUser, error) in
            Task { @MainActor in
                guard let self = self else { return }
                
                if let error = error {
                    self.handleError(error)
                    return
                }
                
                guard let kakaoUser = kakaoUser else {
                    self.handleError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Kakao user info"]))
                    return
                }

                do {
                    let response = try await APIUtils.shared.kakaoLogin(
                        accessToken: token.accessToken
                    )
                    
                    if response.code == "OK", let loginData = response.data {
                        // 서버에서 받은 토큰을 저장
                        TokenManager.shared.saveUserTokens(
                            accessToken: loginData.tokenInfo.accessToken,
                            refreshToken: loginData.tokenInfo.refreshToken
                        )
                        
                        // 토큰 만료 시간도 저장
                        TokenManager.shared.saveTokenExpirationTimes(
                            accessTokenExpiry: loginData.tokenInfo.accessTokenExpiresIn,
                            refreshTokenExpiry: loginData.tokenInfo.refreshTokenExpiresIn
                        )
                        
                        // 유저 정보 생성 (카카오 사용자 정보 사용)
                        let socialUser = User(
                            id: String(kakaoUser.id!),
                            email: kakaoUser.kakaoAccount?.email,
                            name: kakaoUser.kakaoAccount?.profile?.nickname,
                            loginType: .kakao
                        )
                        
                        self.handleLoginSuccess(user: socialUser)
                    } else {
                        // 서버 로그인 실패 시 에러 메시지 표시
                        let errorMessage = response.message
                        self.handleError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                    }
                } catch {
                    self.handleError(error)
                }
            }
        }
    }
    
    // Apple 로그인 결과 처리 (AppleLoginViewModel에서 호출)
    func handleAppleLoginSuccess(userData: AppleLoginModel) {
        let appleUser = User(
            id: userData.userId,
            email: userData.email,
            name: "\(userData.fullName?.givenName ?? "") \(userData.fullName?.familyName ?? "")".trimmingCharacters(in: .whitespaces),
            loginType: .apple
        )
        
        handleLoginSuccess(user: appleUser)
    }
    
    
    
    // login 성공 - @MainActor이므로 DispatchQueue 불필요
    private func handleLoginSuccess(user: User) {
        print("Login Success! 🎉")
        self.isLoading = false
        self.user = user
        self.isLoggedIn = true
    }
    
    // error handler - @MainActor이므로 DispatchQueue 불필요
    private func handleError(_ error: Error) {
        print("Login Failed 👀")
        print(error)
        self.isLoading = false
        self.errorMessage = error.localizedDescription
    }
}

// 새로 추가할 extension
extension AuthViewModel {
    
    // 앱 시작 시 자동 로그인 체크
    func checkAutoLogin() {
        if TokenManager.shared.isTokenValid() {
//            Task {
//                do {
//                    let profileResponse = try await APIUtils.shared.getUserProfile()
//                    let user = User(
//                        id: profileResponse.data.id,
//                        email: profileResponse.data.email,
//                        name: profileResponse.data.name,
//                        loginType: .kakao
//                    )
                    
//                    await MainActor.run {
//                        self.user = user
            print("@@@LOGIN@@@")
                        self.isLoggedIn = true
//                    }
//                } catch APIError.tokenExpired {
//                    await refreshToken()
//                } catch {
//                    await logout()
//                }
//            }
        }
    }
    
    // 로그아웃
    func logout() async {
        TokenManager.shared.clearTokens()
        
        await MainActor.run {
            self.user = nil
            self.isLoggedIn = false
        }
    }
    
    // 토큰 갱신 (나중에 구현)
    func refreshToken() async {
        guard TokenManager.shared.getRefreshToken() != nil else {
            await logout()
            return
        }
        
        // TODO: 리프레시 토큰 API 구현
        await logout() // 임시로 로그아웃 처리
    }
}
