//
//  PrimaryCardView.swift
//  balllog
//
//  Created by 전은혜 on 5/8/25.
//

import SwiftUI

struct PrimaryCardView: View {
    let ballLog: BallLogSimpleResponse
    let teamName = UserPreferences.shared.getTeamName()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 0.0) {
                    VStack(spacing: 0) {
                        HStack {
                            Text("\(ballLog.cheeringTeamName) VS \(ballLog.opposingTeamName)")
                            Spacer()
                            Text("\(ballLog.scoreCheering) : \(ballLog.scoreOpposing)")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .padding(.vertical, 10.0)
                        .padding(.horizontal, 15.0)
                        .foregroundStyle(Color.white)
                        .background(
                            Rectangle()
                                .foregroundStyle(teamMainColor(for: teamName))
                                .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .topRight]))
                                .frame(width: geometry.size.width, height: 40)
                        )
                        Rectangle()
                            .stroke(style: StrokeStyle(
                                lineWidth: 1,
                                lineCap: .square,
                                dash: [5, 5]
                            ))
                            .frame(height: 1)
                            .foregroundStyle(Color.white)
                    }
                    ZStack {
                        Rectangle()
                            .foregroundStyle(teamSubColor(for: teamName))
                        Image("logo_title")
                            .foregroundStyle(Color.white)
                            .opacity(0.5)
                        VStack {
                            Spacer()
                            Rectangle()
                                .stroke(style: StrokeStyle(
                                    lineWidth: 1,
                                    lineCap: .square,
                                    dash: [5, 5]
                                ))
                                .frame(height: 1)
                                .foregroundStyle(Color.white)
                        }
                    }
                    .frame(height: 326)
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4.0) {
                            VStack(alignment: .leading, spacing: 2.0) {
                                Text(ballLog.formattedDate.components(separatedBy: " ").first ?? "")
                                    .font(.system(size: 12))
                                Text(ballLog.title)
                                    .font(.system(size: 20, weight: .bold))
                            }
                            Text("KT wiz 파크")
                                .font(.system(size: 14))
                        }
                        .padding(.leading, 5.0)
                        Spacer()
                        Image("barcode")
                    }
                    .foregroundStyle(Color.white)
                    .padding(10.0)
                    .background(
                        Rectangle()
                            .foregroundStyle(teamSubColor(for: teamName))
                            .clipShape(RoundedCorner(radius: 4, corners: [.bottomLeft, .bottomRight]))
                            .frame(width: geometry.size.width, height: 90)
                    )
                }
                .mask(
                    Image("primarycard")
                        .resizable()
                        .cornerRadius(8)
                        .foregroundStyle(Color.clear)
                        .frame(width: geometry.size.width, height: 457)
                )
            }
            .frame(height: 457)
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
        .frame(height: 457)
    }
}
//
//#Preview {
//    PrimaryCardView(ballLog: <#BallLogSimpleResponse#>)
//}
