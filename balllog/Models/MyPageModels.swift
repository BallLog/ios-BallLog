//
//  MyPageModels.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation

struct MyPageProfile {
    let nickname: String
    let teamName: String
    let winRate: Double
    let winGames: Int
    let totalGames: Int
}

struct WithdrawalRequest: Codable {
    let reason: String?
}

struct WithdrawalResponse: Codable {
    let code: String
    let message: String
}
