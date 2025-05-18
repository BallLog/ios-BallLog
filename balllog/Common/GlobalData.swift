//
//  GlobalData.swift
//  balllog
//
//  Created by 전은혜 on 5/15/25.
//

import Foundation
import SwiftUI

class GlobalData: ObservableObject {
    @Published var myTeam: String = ""
    @Published var winCount: Int = 0
    @Published var totalGames: Int = 0

    // 예: 승률 계산
    var winRate: Double {
        totalGames == 0 ? 0 : Double(winCount) / Double(totalGames)
    }
}
