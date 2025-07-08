//
//  NicknameView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct NicknameView: View {
    @StateObject private var viewModel = NicknameViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                headerSection
                
                inputSection
                
                Spacer()
                
                bottomButtonSection
            }
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
    
    // MARK: - View Components
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text("닉네임")
                .bold()
                .font(.system(size: 24))
                .lineSpacing(36)
            Text("영어, 한글, 숫자를 조합하여")
                .fontWeight(.light)
                .font(.system(size: 14))
                .lineSpacing(21)
            Text("띄어쓰기 포함 10자 이내로 설정해주세요")
                .fontWeight(.light)
                .font(.system(size: 14))
                .lineSpacing(21)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, 30.0)
        .padding(.top, 56.0)
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            ZStack(alignment: .trailing) {
                CustomInputView(
                    label: "",
                    text: $viewModel.nickname,
                    placeholder: "닉네임을 입력해주세요",
                    hasValidation: true,
                    isError: !viewModel.nicknameValid && viewModel.nicknameChecked,
                    isCorrect: viewModel.nicknameValid,
                    maxLength: 10
                )
                .focused($isFocused)
                
                Button(viewModel.isLoading ? "확인 중..." : "중복확인") {
                    Task {
                        await viewModel.checkNickname()
                    }
                }
                .disabled(!viewModel.canCheckNickname)
                .padding([.top, .trailing], 22.0)
            }
            
            if viewModel.nicknameChecked && !viewModel.validationMessage.isEmpty {
                Text(viewModel.validationMessage)
                    .padding(.top, 10.0)
                    .foregroundStyle(viewModel.nicknameValid ? Color("bc_01_60") : Color("error_50"))
            }
        }
        .font(.system(size: 14))
        .padding(.horizontal, 30.0)
        .padding(.top, 12.0)
    }
    
    private var bottomButtonSection: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("처리 중...")
                    .padding()
            } else {
                Button("다음") {
                    Task {
                        await viewModel.proceedToNext()
                    }
                }
                .disabled(!viewModel.canProceed)
                .buttonStyle(CustomButtonStyle())
                .modifier(DefaultButtonWidth())
            }
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigate) {
            TeamSelectView()
        }
        .padding(.bottom, 16.0)
    }
}

#Preview("NicknameView") {
    NicknameView()
}
