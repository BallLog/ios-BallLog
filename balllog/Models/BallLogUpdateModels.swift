//
//  BallLogUpdateModels.swift
//  balllog
//
//  Created by 전은혜 on 8/19/25.
//

import Foundation

// MARK: - Request Models
struct BallLogUpdateRequest: Codable {
    let cheeringTeamId: Int?
    let opposingTeamId: Int?
    let scoreCheering: Int?
    let scoreOpposing: Int?
    let title: String?
    let content: String?
    let stadiumId: Int?
    let matchDate: String?
    let photos: [PhotoRequest]?
}

// MARK: - Response Models
struct BallLogUpdateResponse: Codable {
    let code: String
    let message: String
    let data: BallLogFullResponse
}

struct BallLogFullResponse: Codable {
    let cheeringTeamId: Int
    let opposingTeamId: Int
    let scoreCheering: Int
    let scoreOpposing: Int
    let title: String
    let content: String
    let matchResult: String
    let stadiumId: Int
    let matchDate: String
    let photos: [PhotoResponse]
}