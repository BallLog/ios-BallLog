//
//  LoginView.swift
//  balllog
//
//  Created by 전은혜 on 10/17/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(alignment: .leading) {
                Text("안녕하세요")
                    .font(.title3)
                Text("볼로그 입니다.")
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
            VStack(spacing: 20) {
                GoogleLoginView()
                KakaoLoginBtnView()
            }
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    LoginView()
}
