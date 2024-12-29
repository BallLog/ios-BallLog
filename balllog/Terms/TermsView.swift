//
//  TermsView.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
//

import SwiftUI

struct TermsView: View {
    @StateObject private var termsVM: TermsViewModel
    
    init(termsVM: TermsViewModel = TermsViewModel()) {
        _termsVM = StateObject(wrappedValue: termsVM)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24.0) {
                VStack(alignment: .leading, spacing: 4.0) {
                    Text("약관동의")
                        .bold()
                        .font(.system(size: 24))
                        .lineSpacing(36)
                    Text("서비스 이용을 위한 이용약관 동의")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .lineSpacing(21)
                }
                .padding(.horizontal, 30.0)
                VStack(alignment: .leading, spacing: 5.0) {
                    VStack {
                        Toggle("전체 동의", isOn: $termsVM.isAllAgreed)
                            .toggleStyle(CheckboxToggleStyle())
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                            .lineSpacing(21.6)
                            .frame(height: 65)
                    }
                    VStack(alignment: .leading) {
                        Toggle("서비스 이용약관(필수)", isOn: $termsVM.isTermsAgreed)
                            .toggleStyle(CheckboxToggleStyle())
                            .frame(height: 45)
                        Toggle("개인정보처리방침(필수)", isOn: $termsVM.isPrivacyAgreed)
                            .toggleStyle(CheckboxToggleStyle())
                            .frame(height: 45)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("gray_50"))
                }
                .padding(.horizontal, 20.0)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            .padding(.top, 56.0)
            Spacer()
            VStack {
                Button("다음") {
                    if termsVM.isAllAgreed {
                        termsVM.shouldNavigate = true // 화면 전환 상태 변경
                    }
                }
                .disabled(!termsVM.isAllAgreed)
                .buttonStyle(CustomButtonStyle())
//                CustomButton(
//                    title: "다음", isEnabled: termsVM.isAllAgreed
//                ) {
//                    if termsVM.isAllAgreed {
//                        termsVM.shouldNavigate = true // 화면 전환 상태 변경
//                    }
//                }
            }
            .navigationDestination(isPresented: $termsVM.shouldNavigate) {
                HomeView()
            }
            .padding(.bottom, 16.0)
        }
    }
}

#Preview {
    TermsView()
}
