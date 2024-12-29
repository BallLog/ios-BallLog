//
//  TermsView.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
//

import SwiftUI

struct TermsView: View {
    @StateObject private var termsViewModel: TermsViewModel
    
    init(termsViewModel: TermsViewModel = TermsViewModel()) {
        _termsViewModel = StateObject(wrappedValue: termsViewModel)
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
                        CheckBoxView(isChecked: $termsViewModel.isAllAgreed, title: "전체 동의")
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                            .lineSpacing(21.6)
                    }
                    VStack(alignment: .leading) {
                        CheckBoxView(isChecked: $termsViewModel.isTermsAgreed, title: "서비스 이용약관(필수)")
                        CheckBoxView(isChecked: $termsViewModel.isPrivacyAgreed, title: "개인정보처리방침(필수)")
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
                CustomButton(title: "다음", isEnabled: termsViewModel.isAllAgreed) {
                    if termsViewModel.isAllAgreed {
                        termsViewModel.shouldNavigate = true // 화면 전환 상태 변경
                    }
                }
            }
            .navigationDestination(isPresented: $termsViewModel.shouldNavigate) {
                HomeView()
            }
            .padding(.bottom, 16.0)
        }
    }
}

#Preview {
    TermsView()
}
