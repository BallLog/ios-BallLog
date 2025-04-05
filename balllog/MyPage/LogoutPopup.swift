//
//  TeamConfirmView.swift
//  balllog
//
//  Created by 전은혜 on 1/6/25.
//

import SwiftUI

struct LogoutPopup: View {
    @Environment(\.dismiss) var dismiss // 모달을 닫기 위한 환경 객체
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            VStack {
                Spacer()
                VStack(spacing: 8.0) {
                    Text("로그아웃")
                        .font(.system(size: 24))
                        .bold()
                    Text("로그아웃 하시겠습니까?")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                }
                .foregroundStyle(Color("gray_90"))
                Spacer()
                HStack(spacing: 0.0) {
                    Button("취소") {
                        dismiss()
                    }
                    .frame(width: 158, height:45)
                    .foregroundStyle(Color("gray_70"))
                    .background(Color("gray_20"))
                    Button("로그아웃") {
                        // TODO: 로그아웃 로직 적용
                        dismiss()
                    }
                    .frame(width: 158, height:45)
                    .foregroundStyle(Color("bc_02_10"))
                    .background(Color("bc_02_60"))
                }
                .font(.system(size: 14))
                .fontWeight(.semibold)
            }
            .frame(width: 316, height: 229)
            .background(Color.white)
            .cornerRadius(11.0)
        }
        .ignoresSafeArea()
        .transition(.opacity)
    }
}
