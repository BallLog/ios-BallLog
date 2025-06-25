//
//  TeamSelectView.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import SwiftUI

struct TeamSelectView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var teamSelectVM = TeamSelectViewModel()
    
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
                TeamGridView(viewModel: teamSelectVM)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            .padding(.top, 56.0)
            Spacer()
            VStack {
                Button("다음") {
                    if teamSelectVM.selectedTeam != nil {
                        teamSelectVM.teamConfirm = true // 화면 전환 상태 변경
                    }
                }
                .disabled(teamSelectVM.selectedTeam == nil)
                .buttonStyle(CustomButtonStyle())
                .modifier(DefaultButtonWidth())
            }
            .padding(.bottom, 16.0)
        }
        .fullScreenCover(isPresented: $teamSelectVM.teamConfirm) {
            TeamConfirmView(selectedTeam: $teamSelectVM.selectedTeam, onConfirm: teamSelectVM.confirmTeam)
                .presentationBackground(.ultraThinMaterial)
        }
        .navigationDestination(isPresented: $teamSelectVM.shouldNavigate) {
            ServiceView()
        }
        .navigationBarBackButtonHidden(true)
    }
}
