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
    let id: Int
    let cheeringTeamName: String
    let opposingTeamName: String
    let scoreCheering: Int
    let scoreOpposing: Int
    let stadiumId: Int
    let title: String
    let content: String
    let matchDate: String
    let thumbnailUrl: String?
    
    // 계산된 속성들
    var isWin: Bool {
        scoreCheering > scoreOpposing
    }
    
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy/MM/dd"
        outputFormatter.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: matchDate) {
            return outputFormatter.string(from: date)
        } else {
            return "날짜 변환 실패"
        }
    }

}

// MARK: - UI Models
struct CardItem: Identifiable, Hashable {
    let id = UUID()
    let ballLogId: Int
    let title: String
    let content: String
    let isPrimary: Bool
}
