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
            HStack {
                Image("KakaoLogo")
                Spacer()
                Text("카카오 로그인")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                Spacer()
            }
            .padding(.vertical, 16.0)
            .padding(.horizontal, 25.0)
            .foregroundColor(Color("gray_90"))
            .background(Color.kakaoYellow)
            .cornerRadius(6) // 라운드 6 적용
        }
        .disabled(authViewModel.isLoading)
    }
}

extension Color {
    static let kakaoYellow = Color(red: 254/255, green: 229/255, blue: 0/255, opacity: 1)
}


#Preview {
    KakaoLoginBtnView()
        .environmentObject(AuthViewModel())
}
