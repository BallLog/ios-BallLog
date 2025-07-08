//
//  TeamSelectView.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import SwiftUI

struct TeamSelectView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = TeamSelectViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24.0) {
                VStack(alignment: .leading, spacing: 4.0) {
                    Text("응원구단 선택")
                        .bold()
                        .font(.system(size: 24))
                        .lineSpacing(36)
                    Text("내가 응원하는 구단을 선택 해주세요")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .lineSpacing(21)
                }
                .padding(.horizontal, 30.0)
                
                TeamGridView(viewModel: viewModel)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 56.0)
            
            Spacer()
            
            VStack {
                Button("다음") {
                    if viewModel.selectedTeam != nil {
                        viewModel.teamConfirm = true
                    }
                }
                .disabled(viewModel.selectedTeam == nil)
                .buttonStyle(CustomButtonStyle())
                .modifier(DefaultButtonWidth())
            }
            .padding(.bottom, 16.0)
        }
        .fullScreenCover(isPresented: $viewModel.teamConfirm) {
            TeamConfirmView(
                selectedTeam: $viewModel.selectedTeam,
                onConfirm: viewModel.confirmTeam
            )
            .presentationBackground(.ultraThinMaterial)
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigate) {
            ServiceView()
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
