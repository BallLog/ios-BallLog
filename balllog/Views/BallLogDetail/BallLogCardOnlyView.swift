//
//  BallLogCardOnlyView.swift
//  balllog
//
//  Created by 전은혜 on 8/17/25.
//

import SwiftUI

struct BallLogCardOnlyView: View {
    let displayData: BallLogDisplayData
    let teamName = UserPreferences.shared.getTeamName()
    let theme: Int?
    
    var body: some View {
        BallLogCardContentView(displayData: displayData, theme: theme)
        .background(
            Rectangle()
                .foregroundStyle(teamThemeBgColor(for: teamName).shapeStyle)
       )
   }
}

#Preview {
    let sampleData = BallLogDetailData(
        id: 1,
        title: "잠실에서의 짜릿한 승리!",
        content: "9회말 역전승으로 기분 좋은 하루였어요. 친구들과 함께 응원하니 더욱 재미있었습니다.",
        matchDate: "2024-08-17T19:00:00",
        stadiumId: 1,
        cheeringTeamId: 1,
        opposingTeamId: 2,
        scoreCheering: 7,
        scoreOpposing: 5,
        photos: [],
        matchResult: "WIN"
    )
    
    return BallLogCardOnlyView(
        displayData: BallLogDisplayData(from: sampleData),
        theme: 1
    )
    .frame(width: 340, height: 590)
    .background(Color.white)
}
