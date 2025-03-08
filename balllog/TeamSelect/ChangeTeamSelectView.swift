//
//  ChangeTeamSelectView.swift
//  balllog
//
//  Created by 전은혜 on 3/4/25.
//


import SwiftUI

struct ChangeTeamSelectView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var teamSelectVM: TeamSelectViewModel
    
    init(teamSelectVM: TeamSelectViewModel = TeamSelectViewModel()) {
        _teamSelectVM = StateObject(wrappedValue: teamSelectVM)
    }
    
    let teamData: [[String]] = [["삼성 라이온즈", "롯데 자이언츠"], ["SSG 랜더스", "KIA 타이거즈"], ["LG 트윈스", "두산 베어스"], ["한화 이글스", "키움 히어로즈"], ["KT 위즈", "NC 다이노스"]]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .center) {
                    Button(action: {
                        dismiss()
                    }){
                        Image("dismiss")
                    }
                    Text("응원구단 변경")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .lineSpacing(27)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
                .frame(width: .infinity, height: 60)
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
            MyPageView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChangeTeamSelectView()
}
