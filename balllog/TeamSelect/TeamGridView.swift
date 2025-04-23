//
//  TeamGridView.swift
//  balllog
//
//  Created by 전은혜 on 4/23/25.
//

import SwiftUI

struct TeamGridView: View {
    @ObservedObject var viewModel: TeamSelectViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            ForEach(Array(viewModel.teamData.enumerated()), id: \.offset) { row in
                TeamRowView(teams: row.element, viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20.0)
    }
}

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
