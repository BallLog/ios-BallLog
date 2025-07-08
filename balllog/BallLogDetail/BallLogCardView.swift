//
//  BallLogCardView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//
import SwiftUI

struct BallLogCardView: View {
    @ObservedObject var viewModel: BallLogCreateViewModel
    @FocusState var isFocused: Bool

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
                    .foregroundStyle(teamThemeBgColor(for: UserPreferences.shared.getTeamName()).shapeStyle)
            )
            .padding(.leading, 18)
            .frame(width: geometry.size.width - 18)
        }
    }
    // 복잡한 expression을 분리
    private var currentTeamColor: Color {
        return teamMainColor(for: UserPreferences.shared.getTeamName())
    }
}
