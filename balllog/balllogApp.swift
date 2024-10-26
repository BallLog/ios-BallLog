//
//  balllogApp.swift
//  balllog
//
//  Created by 전은혜 on 10/17/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

@main
struct balllogApp: App {
    init() {
        // SDK 초기화
        KakaoSDK.initSDK(appKey:"24e62fbdc1d17bceba6990d424c48972")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                      // Check if `user` exists; otherwise, do something with `error`
                    }
                }
                .onOpenURL { url in
                    // 카카오 로그인 URL 처리
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    // 구글 로그인 URL 처리
                    else if url.scheme?.contains("com.googleusercontent.apps") == true {
                        _ = GIDSignIn.sharedInstance.handle(url)
                    }
                }
        }
    }
}
