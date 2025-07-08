//
//  LogoutPopup.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct LogoutPopup: View {
    @ObservedObject var viewModel: MyPageViewModel
    @Environment(\.dismiss) var dismiss
    
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
                
                if viewModel.isLoading {
                    ProgressView("로그아웃 중...")
                        .padding()
                } else {
                    HStack(spacing: 0.0) {
                        Button("취소") {
                            viewModel.hideLogoutPopup()
                            dismiss()
                        }
                        .frame(width: 158, height: 45)
                        .foregroundStyle(Color("gray_70"))
                        .background(Color("gray_20"))
                        
                        Button("로그아웃") {
                            Task {
                                await viewModel.logout()
                                dismiss()
                            }
                        }
                        .frame(width: 158, height: 45)
                        .foregroundStyle(Color("bc_02_10"))
                        .background(Color("bc_02_60"))
                    }
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                }
            }
            .frame(width: 316, height: 229)
            .background(Color.white)
            .cornerRadius(11.0)
        }
        .ignoresSafeArea()
        .transition(.opacity)
    }
}
