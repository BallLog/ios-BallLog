//
//  KakaoLoginBtnView.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct KakaoLoginBtnView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Button {
            authViewModel.handleKakaoLogin()
        } label: {
            Image("kakao_login_medium_narrow")
        }
        .disabled(authViewModel.isLoading)
    }
}
