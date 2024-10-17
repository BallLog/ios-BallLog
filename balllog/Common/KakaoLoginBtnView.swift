//
//  KakaoLoginBtnView.swift
//  balllog
//
//  Created by 전은혜 on 10/17/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct KakaoLoginBtnView: View {
    var body: some View {
        Button {
            // 카카오톡 실행 가능 여부 확인
            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡 앱 로그인 인증
                UserApi.shared.loginWithKakaoTalk{(OAuthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    if let OAuthToken = OAuthToken{
                        print("success")
                    }
                    
                }
            } else {
                // 미설치 시 카카오 계정 로그인
                UserApi.shared.loginWithKakaoAccount {(OAuthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    if let OAuthToken = OAuthToken {
                        print("success")
                    }
                }
                
            }
        } label: {
            Image("kakao_login_medium_narrow")
        }
    }
}

#Preview {
    KakaoLoginBtnView()
}
