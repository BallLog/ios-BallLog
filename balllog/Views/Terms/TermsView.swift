//
//  TermsView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct TermsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = TermsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24.0) {
                headerView
                agreementSection
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 56.0)
            
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
    
    // MARK: - View Components
    private var headerView: some View {
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
    }
    
    private var agreementSection: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            VStack {
                Toggle("전체 동의", isOn: $viewModel.isAllAgreed)
                    .toggleStyle(CheckboxToggleStyle())
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
                    .lineSpacing(21.6)
                    .frame(height: 65)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Toggle("서비스 이용약관(필수)", isOn: $viewModel.isTermsAgreed)
                        .toggleStyle(CheckboxToggleStyle())
                    
                    Spacer()
                    
                    NavigationLink(destination: TermsDetailView(contentType: .terms)) {
                        Text("보기")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray_50"))
                            .underline()
                    }
                }
                .frame(height: 45)
                
                HStack {
                    Toggle("개인정보처리방침(필수)", isOn: $viewModel.isPrivacyAgreed)
                        .toggleStyle(CheckboxToggleStyle())
                    
                    Spacer()
                    
                    NavigationLink(destination: TermsDetailView(contentType: .privacy)) {
                        Text("보기")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray_50"))
                            .underline()
                    }
                }
                .frame(height: 45)
            }
            .font(.system(size: 14))
            .foregroundColor(Color("gray_50"))
        }
        .padding(.horizontal, 20.0)
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
            NicknameView()
                .environmentObject(authViewModel)
        }
        .padding(.bottom, 16.0)
    }
}
