//
//  LogCardView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI

struct LogCardView: View {
    @ObservedObject var viewModel: LogAddViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image("linecard")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: .infinity)
                .foregroundStyle(Color("gray_40"))
                .overlay(
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
                )
        }
    }
}
