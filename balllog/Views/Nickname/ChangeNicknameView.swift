//
//  ChangeNicknameView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct ChangeNicknameView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = NicknameViewModel(isUpdateMode: true)
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 12.0) {
                    headerSection
                    inputSection
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 70)
                
                VStack {
                    DetailHeaderView(title: "닉네임 변경")
                    Spacer()
                    bottomButtonSection
                }
                .padding(.bottom, 16.0)
            }
            .navigationBarBackButtonHidden(true)
            .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("확인") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onChange(of: viewModel.shouldNavigate) { _, shouldNavigate in
                if shouldNavigate {
                    dismiss()
                }
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
        .padding(.horizontal, 30.0)
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            ZStack(alignment: .trailing) {
                CustomInputView(
                    label: "",
                    text: $viewModel.nickname,
                    placeholder: "닉네임을 입력해주세요",
                    hasValidation: true,
                    isError: !viewModel.nicknameValid && !viewModel.validationMessage.isEmpty,
                    isCorrect: viewModel.nicknameValid,
                    maxLength: 10
                )
                .focused($isFocused)
                .onAppear(perform : UIApplication.shared.hideKeyboard)
            }
            
            if !viewModel.validationMessage.isEmpty {
                Text(viewModel.validationMessage)
                    .padding(.top, 10.0)
                    .foregroundStyle(viewModel.nicknameValid ? Color("bc_01_60") : Color("error_50"))
            }
        }
        .font(.system(size: 14))
        .padding(.horizontal, 30.0)
    }
    
    private var bottomButtonSection: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("처리 중...")
                    .padding()
            } else {
                Button("변경하기") {
                    Task {
                        await viewModel.updateNickname()
                    }
                }
                .disabled(viewModel.nickname.trimmingCharacters(in: .whitespaces).isEmpty || viewModel.isCurrentNickname)
                .buttonStyle(CustomButtonStyle())
                .modifier(DefaultButtonWidth())
            }
        }
    }
}


#Preview("ChangeNicknameView") {
    ChangeNicknameView()
}
