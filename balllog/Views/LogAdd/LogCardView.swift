//
//  LogCardView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI

struct LogCardView: View {
    @ObservedObject var viewModel: BallLogCreateViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            LogFormContentView(
                title: $viewModel.title,
                gameDate: $viewModel.gameDate,
                stadium: $viewModel.stadium,
                myTeam: $viewModel.myTeam,
                myTeamScore: $viewModel.myTeamScore,
                opposingTeam: $viewModel.opposingTeam,
                opposingTeamScore: $viewModel.opposingTeamScore,
                photoList: $viewModel.photoList,
                logContent: $viewModel.logContent,
                isFocused: _isFocused
            )
            .overlay(
                Rectangle()
                    .stroke(Color("gray_40"), lineWidth: 1.0)
            )
            .padding(.leading, 18)
            
            Spacer()
                .frame(width: 18)
        }
    }
}

#Preview {
    LogAddView()
}
