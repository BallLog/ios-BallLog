//
//  WithdrawalView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct WithdrawalView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: WithdrawalViewModel
    @FocusState private var isFocused: Bool
    
    init(authViewModel: AuthViewModel) {
        self._viewModel = StateObject(wrappedValue: WithdrawalViewModel(authViewModel: authViewModel))
    }
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8.0) {
                    Text("탈퇴 유의사항")
                        .fontWeight(.semibold)
                        .font(.system(size: 14.0))
                    VStack(alignment: .leading, spacing: 14.0) {
                        Text(" ·  탈퇴시 계정은 삭제되며 복구되지 않습니다.")
                        Text(" ·  탈퇴시 모든 정보는 삭제되며 복구되지 않습니다.")
                    }
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .lineSpacing(14 * (2.07 - 1))
                    .kerning(14 * 0.02)
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("서비스를 떠나는 이유를 알려주세요")
                            .fontWeight(.semibold)
                            .font(.system(size: 14.0))
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text("고객님의 소중한 피드백을 담아")
                            Text("더 나은 서비스로 보답드리도록 하겠습니다.")
                        }
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .kerning(14 * 0.02)
                    }
                    CustomInputView(
                        label: "",
                        isArea: true,
                        text: $viewModel.withdrawalReason,
                        placeholder: "내용을 입력해주세요"
                    )
                }
                
                Spacer()
                
                Toggle("회원 탈퇴 유의사항을 확인하였으며 동의합니다.", isOn: $viewModel.hasAgreed)
                    .font(.system(size: 14))
                    .foregroundColor(Color("gray_50"))
                    .toggleStyle(CheckboxToggleStyle())
                    .frame(height: 45)
            }
            .foregroundStyle(Color("gray_90"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 75.0)
            .padding(.horizontal, 20.0)
            
            VStack {
                DetailHeaderView(title: "회원탈퇴")
                Spacer()
                VStack {
                    Button("회원탈퇴") {
                        Task {
                            await viewModel.withdrawUser()
                        }
                    }
                    .disabled(!viewModel.canWithdraw || viewModel.isLoading)
                    .buttonStyle(CustomButtonStyle())
                    .modifier(DefaultButtonWidth())
                    
                    if viewModel.isLoading {
                        ProgressView("탈퇴 처리 중...")
                            .padding()
                    }
                }
                .padding(.bottom, 16.0)
            }
        }
        .simultaneousGesture(
            TapGesture().onEnded { isFocused = false }
        )
        .navigationBarBackButtonHidden(true)
        .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("확인") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
