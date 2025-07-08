//
//  balllogApp.swift
//  balllog
//
//  Created by 전은혜 on 10/17/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct balllogApp: App {
    init() {
        // SDK 초기화
        KakaoSDK.initSDK(appKey:"24e62fbdc1d17bceba6990d424c48972")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // 카카오 로그인 URL 처리
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .environment(\.font, .custom("Pretendard", size: 17)) // 전체 적용
        }
    }
}
