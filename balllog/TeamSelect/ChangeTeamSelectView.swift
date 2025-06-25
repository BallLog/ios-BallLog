//
//  ChangeTeamSelectView.swift
//  balllog
//
//  Created by 전은혜 on 3/4/25.
//


import SwiftUI

struct ChangeTeamSelectView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var teamSelectVM = TeamSelectViewModel()

    let teamData: [[String]] = [["삼성 라이온즈", "롯데 자이언츠"], ["SSG 랜더스", "KIA 타이거즈"], ["LG 트윈스", "두산 베어스"], ["한화 이글스", "키움 히어로즈"], ["KT 위즈", "NC 다이노스"]]
    
    var body: some View {
        NavigationStack {
            ZStack {
                TeamGridView(viewModel: teamSelectVM)
                // 고정 뷰 (헤더, 버튼)
                VStack {
                    // 헤더
                    DetailHeaderView(title:"응원구단 변경")
                    Spacer()
                    // 버튼
                    VStack {
                        Button("다음") {
                            if teamSelectVM.selectedTeam != nil {
                                // 뒤로가기 동작으로 마이페이지 복귀
                                dismiss()
                            }
                        }
                        .disabled(teamSelectVM.selectedTeam == nil)
                        .buttonStyle(CustomButtonStyle())
                        .modifier(DefaultButtonWidth())
                    }
                    .padding(.bottom, 16.0)
                
                }
            }
        }
        .fullScreenCover(isPresented: $teamSelectVM.teamConfirm) {
            TeamConfirmView(selectedTeam: $teamSelectVM.selectedTeam, onConfirm: teamSelectVM.confirmTeam)
                .presentationBackground(.ultraThinMaterial)
        }
        .navigationBarBackButtonHidden(true)
    }
}
