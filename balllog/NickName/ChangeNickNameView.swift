//
//  ChangeNickNameView.swift
//  balllog
//
//  Created by 전은혜 on 5/18/25.
//

import SwiftUI

struct ChangeNickNameView: View {
    @StateObject private var nicknameVM: NickNameViewModel
    
    init(nicknameVM: NickNameViewModel = NickNameViewModel()) {
        _nicknameVM = StateObject(wrappedValue: nicknameVM)
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 12.0) {
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
                    VStack(alignment: .leading, spacing: 10.0) {
                        ZStack(alignment: .trailing) {
                            CustomInputView(label: "", text: $nicknameVM.nickname, placeholder: "닉네임을 입력해주세요", hasValidation: true, isError: !nicknameVM.nicknameValid && nicknameVM.nicknameChecked, isCorrect: nicknameVM.nicknameValid, maxLength : 10)
                                .focused($isFocused)
                            Button("중복확인") {
                                nicknameVM.checkNickname()
                            }
                            .disabled(nicknameVM.nickname.isEmpty)
                            .padding([.top, .trailing], 22.0)
                        }
                        if nicknameVM.nicknameChecked {
                            if nicknameVM.nicknameValid{
                                Text("사용가능한 닉네임입니다.")
                                    .padding(.top, 10.0)
                                    .foregroundStyle(Color("bc_01_60"))
                            } else {
                                Text("이미 사용중인 닉네임입니다.")
                                    .padding(.top, 10.0)
                                    .foregroundStyle(Color("error_50"))
                            }
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal, 30.0)
                    Spacer()
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                .padding(.top, 70)
                VStack {
                    DetailHeaderView(title: "닉네임 변경")

                    Spacer()
                    
                    Button("다음") {
                        if nicknameVM.nicknameValid {
                            nicknameVM.shouldNavigate = true // 화면 전환 상태 변경
                        }
                    }
                    .disabled(!nicknameVM.nicknameValid)
                    .buttonStyle(CustomButtonStyle())
                    .modifier(DefaultButtonWidth())
                }
                .navigationDestination(isPresented: $nicknameVM.shouldNavigate) {
                    TeamSelectView()
                }
                .padding(.bottom, 16.0)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ChangeNickNameView()
}
