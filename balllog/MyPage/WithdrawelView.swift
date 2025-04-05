//
//  WithdrawelView.swift
//  balllog
//
//  Created by 전은혜 on 4/5/25.
//

import SwiftUI

struct WithdrawelView: View {
    @State private var text: String = ""
    @State private var withdrawel: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            // 터치영역
            Color.white
            
            VStack(alignment: .leading, spacing: 22){
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
                    .lineSpacing(14 * (2.07 - 1)) // 약 14.98
                    .kerning(14 * 0.02) // 약 0.28
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
                        .kerning(14 * 0.02) // 약 0.28
                    }
                    CustomInputView(label: "", isArea: true, text: $text, placeholder: "내용을 입력해주세요")
                }
                Spacer()
                Toggle("회원 탈퇴 유의사항을 확인하였으며 동의합니다.", isOn: $withdrawel)
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
                // 헤더
                DetailHeaderView(title: "회원탈퇴")
                Spacer()
                VStack {
                    Button("회원탈퇴") {
                        if text != "" || !withdrawel {
                            // TODO: 탈퇴로직
                        }
                    }
                    .disabled(text == "" || !withdrawel)
                    .buttonStyle(CustomButtonStyle())
                    .modifier(DefaultButtonWidth())
                }
                .padding(.bottom, 16.0)
            }
        }
        .simultaneousGesture( // ✅ UI 요소 터치 시 키보드 숨김
            TapGesture().onEnded { isFocused = false }
        )
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WithdrawelView()
}
