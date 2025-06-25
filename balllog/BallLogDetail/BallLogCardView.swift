//
//  BallLogCardView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//
import SwiftUI

struct BallLogCardView: View {
    @ObservedObject var viewModel: LogAddViewModel
    @FocusState var isFocused: Bool
    @EnvironmentObject var globalData: GlobalData
    // api 호출
    // /api/v1/ball-log/{ballLogId}

    var body: some View {
        GeometryReader { geometry in
            BallLogCardContentView(
                title_api: "오늘의 승리요정!",
                matchDate: "2025-03-04T17:00:00",
                scoreCheering: 3,
                scoreOpposing: 1,
                cheeringTeamId: 1,
                opposingTeamId: 3,
                photos_api: [], // 빈 배열이면 기본 로고 표시
                content_api: "오늘 오랜만에 직관 갔는데 승요했음~ 오늘 경기 진짜 잘했고 앞으로도 이렇게만 했으면 좋겠다",
                winRate_api: 0.7,
                stadiumId: 2
            )
            .background(
                Rectangle()
                    .foregroundStyle(teamThemeBgColor(for: globalData.selectedTeam?.name).shapeStyle)
            )
            .padding(.leading, 18)
            .frame(width: geometry.size.width - 18)
        }
    }
    // 복잡한 expression을 분리
    private var currentTeamColor: Color {
        return teamMainColor(for: globalData.selectedTeam?.name)
    }
}


#Preview {
    BallLogDetailView()
        .environmentObject({
            let data = GlobalData.shared
            let team = TeamData.shared.findNameTeam(by: "롯데 자이언츠")!
            print(team)
            data.setMyTeam(team)
            data.winCount = 7
            data.totalGames = 10
            return data
        }())
}
