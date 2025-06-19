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
        Rectangle()
            .stroke(style: StrokeStyle(
                lineWidth: 1,
                lineCap: .square,
                dash: [5, 10]
            ))
            .frame(height: 1)
            .foregroundColor(theme < 2 ? teamMainColor(for: myTeam) : Color.white)
    }
}


struct DotLineInputView: View {
    var body: some View {
        Rectangle()
            .stroke(style: StrokeStyle(
                lineWidth: 1,
                lineCap: .square,
                dash: [5, 5]
            ))
            .frame(height: 1)
            .foregroundColor(Color("gray_40"))
    }
}
