//
//  BallLogModels.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import Foundation

// MARK: - API Response Models
struct BallLogResponse: Codable {
    let code: String
    let message: String
    let data: BallLogData
}

struct BallLogData: Codable {
    let content: [BallLogSimpleResponse]
    let first: Bool
    let last: Bool
}

struct BallLogSimpleResponse: Codable, Identifiable {
    var id = UUID()
    let cheeringTeamName: String
    let opposingTeamName: String
    let scoreCheering: Int
    let scoreOpposing: Int
    let title: String
    let content: String
    let matchDate: String
    let thumbnailUrl: String
    
    // 계산된 속성들
    var isWin: Bool {
        scoreCheering > scoreOpposing
    }
    
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: matchDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "M/d (E) HH:mm"
            displayFormatter.locale = Locale(identifier: "ko_KR")
            return displayFormatter.string(from: date)
        }
        return matchDate
    }
}

// MARK: - UI Models
struct CardItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
    let isPrimary: Bool
}
