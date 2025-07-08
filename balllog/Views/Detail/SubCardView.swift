//
//  SubCardView.swift
//  balllog
//
//  Created by 전은혜 on 5/8/25.
//

import SwiftUI

struct SubCardView: View {
    let ballLog: BallLogSimpleResponse
    let teamName = UserPreferences.shared.getTeamName()
    
    var body: some View {
        NavigationLink(destination: BallLogDetailView()) {
            GeometryReader { geometry in
                VStack(spacing: 0.0) {
                    HStack {
                        Text(ballLog.title)
                        Spacer()
                        Text(ballLog.formattedDate.components(separatedBy: " ").first ?? "")
                    }
                    .font(.system(size: 10, weight: .bold))
                    .padding(.vertical, 6.5)
                    .padding(.horizontal, 20.0)
                    .foregroundStyle(Color.white)
                    .background(
                        Rectangle()
                            .foregroundStyle(teamMainColor(for: teamName))
                            .clipShape(RoundedCorner(radius: 6, corners: [.topLeft, .topRight]))
                            .frame(width: geometry.size.width, height: 28)
                    )
                    .frame(width: geometry.size.width, height: 28)
                    HStack(alignment: .center, spacing: 20.0) {
                        Text(ballLog.cheeringTeamName)
                        HStack() {
                            Text("\(ballLog.scoreCheering)")
                            Text(":")
                            Text("\(ballLog.scoreOpposing)")
                        }
                        .font(.system(size: 30, weight: .bold))
                        Text(ballLog.opposingTeamName)
                    }
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(teamFontColor(for:teamName))
                    .background(
                        Rectangle()
                            .foregroundStyle(teamBgColor(for:teamName))
                            .clipShape(RoundedCorner(radius: 6, corners: [.bottomLeft, .bottomRight]))
                            .frame(width: geometry.size.width, height: 65)
                            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                    )
                    .frame(width: geometry.size.width, height: 65)
                }
                .frame(width: geometry.size.width, height: 93)
            }
            .frame(height: 93)
        }
    }
}
