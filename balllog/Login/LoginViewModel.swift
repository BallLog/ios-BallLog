//
//  LoginViewModel.swift
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

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    
    // 카카오 로그인
    func handleKakaoLogin() {
        isLoading = true
        
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 앱 로그인 인증
            UserApi.shared.loginWithKakaoTalk{(OAuthToken, error) in
                if let error = error {
                    print(error)
                }
                if let OAuthToken = OAuthToken{
                    self.handleKakaoLoginResult(oauthToken: OAuthToken, error: error)
                }
                
            }
        } else {
            // 미설치 시 카카오 계정 로그인
            UserApi.shared.loginWithKakaoAccount {(OAuthToken, error) in
                if let error = error {
                    print(error)
                }
                if let OAuthToken = OAuthToken {
                    self.handleKakaoLoginResult(oauthToken: OAuthToken, error: error)
                }
            }
            
        }
    }
    
    func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?){
        if let error = error {
            handleError(error)
            return
        }
        
        UserApi.shared.me { [weak self] (user, error) in
            if let error = error {
                self?.handleError(error)
                return
            }
            guard let kakaoUser = user else {
                self?.handleError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Kakao user info"]))
                return
            }
            
            let socialUser = User(
                id: String(kakaoUser.id!),
                email: kakaoUser.kakaoAccount?.email,
                name: kakaoUser.kakaoAccount?.profile?.nickname,
                loginType: .kakao
            )
            
            self?.handleLoginSuccess(user: socialUser)
        }
    }
    
    // login 성공
    private func handleLoginSuccess(user: User) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.user = user
            self.isLoggedIn = true
        }
    }
    
    // error handler
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }
}
