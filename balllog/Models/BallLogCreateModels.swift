//
//  BallLogCreateModels.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import Foundation

// MARK: - Request Models
struct BallLogCreateRequest: Codable {
    let cheeringTeamId: Int
    let opposingTeamId: Int
    let scoreCheering: Int
    let scoreOpposing: Int
    let title: String
    let content: String
    let stadiumId: Int
    let matchDate: String?
    let photos: [PhotoRequest]
}

struct PhotoRequest: Codable {
    let imgUrl: String
    let sequence: Int
}

// MARK: - Response Models
struct BallLogCreateResponse: Codable {
    let code: String
    let message: String
    let data: BallLogCreateData
}

struct BallLogCreateData: Codable {
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
    let winRate: Double?  // 승률 추가
}

struct PhotoResponse: Codable {
    let imgUrl: String
    let sequence: Int
}

// MARK: - Helper Models
struct TeamInfo {
    let id: Int
    let name: String
}

struct StadiumInfo {
    let id: Int
    let name: String
}
