//
//  TeamSelectView.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import SwiftUI

struct TeamSelectView: View {
    @StateObject private var teamSelectVM: TeamSelectViewModel
    
    init(teamSelectVM: TeamSelectViewModel = TeamSelectViewModel()) {
        _teamSelectVM = StateObject(wrappedValue: teamSelectVM)
    }
    
    let teamData: [[String]] = [["삼성 라이온즈", "롯데 자이언츠"], ["SSG 랜더스", "KIA 타이거즈"], ["LG 트윈스", "두산 베어스"], ["한화 이글스", "키움 히어로즈"], ["KT 위즈", "NC 다이노스"]]
    
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
                VStack(alignment: .center, spacing: 30) {
                    ForEach(teamData, id: \.self) { row in
                        HStack(spacing: 16) {
                            ForEach(row, id: \.self) { item in
                                let buttonActive = teamSelectVM.selectedTeam == item
                                Button(item) {
                                    teamSelectVM.changeSelectedTeam(buttonActive ? "" : item)
                                }
                                .buttonStyle(
                                    TeamButtonStyle(state: buttonActive ? .selected : .nonselected)
                                )
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
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
                    if teamSelectVM.selectedTeam != "" {
                        teamSelectVM.teamConfirm = true // 화면 전환 상태 변경
                    }
                }
                .disabled(teamSelectVM.selectedTeam == "")
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
            HomeView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TeamSelectView()
}
