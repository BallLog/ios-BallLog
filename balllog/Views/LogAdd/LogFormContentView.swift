//
//  LogFormContentView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI
import PhotosUI

struct LogFormContentView: View {
    @Binding var title: String
    @Binding var gameDate: Date?
    @Binding var stadium: String
    @Binding var myTeam: String
    @Binding var myTeamScore: String
    @Binding var opposingTeam: String
    @Binding var opposingTeamScore: String
    @Binding var photoList: [PhotosPickerItem]
    @Binding var logContent: String
    
    @FocusState var isFocused: Bool

    @FocusState private var titleFocused: Bool
    @FocusState private var textAreaFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack {
                TextInputView(text: $title, placeholder: "제목을 입력해 주세요", fontWeight: .bold)
                    .focused($titleFocused)
            }
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            
            VStack (alignment: .leading, spacing: 0){
                LogFormGameInfoView(
                    gameDate: $gameDate,
                    myTeam: $myTeam,
                    myTeamScore: $myTeamScore,
                    opposingTeam: $opposingTeam,
                    opposingTeamScore: $opposingTeamScore
                )
                LogFormDiaryView(
                    selectedItems: $photoList,
                    diaryContent: $logContent,
                    isFocused: _isFocused,
                    textAreaFocused: _textAreaFocused
                )
                LogFormBottomView(stadium: $stadium)
            }
            .background(
                Rectangle()
                    .stroke(Color("gray_40"), lineWidth: 1.0)
            )
        }
        .padding(14)
        .onChange(of: titleFocused) { _, focused in
            isFocused = focused
        }
        .onChange(of: textAreaFocused) { _, focused in
            isFocused = focused
        }
    }
}

#Preview {
    LogAddView()
}
