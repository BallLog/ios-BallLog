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
        KakaoSDK.initSDK(appKey:"24e62fbdc1d17bceba6990d424c48972")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
