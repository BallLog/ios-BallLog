//
//  WinRateView.swift
//  balllog
//
//  Created by 전은혜 on 4/29/25.
//

import SwiftUI

struct WinRateView: View {
    var myTeam: String
    var theme: Int
    
    var body: some View {
        VStack (spacing: 5.0) {
            // 승률 텍스트
            HStack(alignment: .center) {
                Text("직관 승률 70%")
                    .font(.custom("Pretendard Variable", size: 12))
                    .fontWeight(.medium)
                    .lineSpacing(0)
                    .kerning(0)
                Spacer()
                HStack(alignment: .center, spacing: 6.0) {
                    Text("020승")
                        .font(.custom("Pretendard Variable", size: 18))
                        .fontWeight(.bold)
                        .lineSpacing(0)
                        .kerning(0)
                    Text("/ 030경기")
                        .font(.custom("Pretendard Variable", size: 10))
                        .fontWeight(.regular)
                        .lineSpacing(0)
                        .kerning(0)
                }
            }
            .foregroundColor(theme < 2 ? teamSubColor(for: myTeam) : Color.white)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(theme < 2 ? teamSubColor(for: myTeam) : Color.white, lineWidth: 1)
                        .frame(height: 6)
                    Rectangle()
                        .foregroundStyle(theme < 2 ? teamSubColor(for: myTeam) : Color.white)
                        .frame(width: geometry.size.width * 0.5, height: 6)
                        .clipShape(RoundedCorner(radius: 4, corners: [.topLeft, .bottomLeft]))
                }
            }
        }
    }
}
