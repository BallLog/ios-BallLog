//
//  DotLineView.swift
//  balllog
//
//  Created by 전은혜 on 4/29/25.
//

import SwiftUI

struct DotLineView: View {
    var myTeam: String;
    var theme: Int;

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0.5))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0.5))
            }
            .stroke(style: StrokeStyle(
                lineWidth: 1,
                lineCap: .square,
                dash: [5]
            ))
        }
        .frame(height: 1)
        .foregroundColor(theme < 2 ? teamMainColor(for: myTeam) : Color.white)
    }
}


struct DotLineInputView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0.5))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0.5))
            }
            .stroke(style: StrokeStyle(
                lineWidth: 1,
                lineCap: .square,
                dash: [5]
            ))
        }
        .frame(height: 1)
        .foregroundColor(Color("gray_40"))
    }
}
