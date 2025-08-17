//
//  BallLogCardView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct BallLogCardView: View {
    let displayData: BallLogDisplayData
    let teamName = UserPreferences.shared.getTeamName()
    
    var body: some View {
        GeometryReader { geometry in
            BallLogCardOnlyView(displayData: displayData, theme: 0)
                .padding(.leading, 18)
                .frame(width: max(0, geometry.size.width - 18))
        }
    }
}
