//
//  TeamRowView.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import SwiftUI

struct TeamRowView: View {
    let teams: [Team]
    @ObservedObject var viewModel: TeamSelectViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(teams) { team in
                let buttonActive = viewModel.selectedTeam == team
                Button(team.name) {
                    viewModel.changeSelectedTeam(team)
                }
                .buttonStyle(
                    TeamButtonStyle(state: buttonActive ? .selected : .nonselected)
                )
            }
        }
    }
}
