//
//  BallLogDetailModels.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation

struct BallLogDetailResponse: Codable {
    let code: String
    let message: String
    let data: BallLogDetailData
}

struct BallLogDetailData: Codable {
    let id: Int
    let title: String
    let content: String
    let matchDate: String
    let stadiumId: Int
    let cheeringTeamId: Int
    let opposingTeamId: Int
    let scoreCheering: Int
    let scoreOpposing: Int
    let photos: [PhotoDetailResponse]
    let winRate: Double
    let createdAt: String
    let updatedAt: String
}

struct PhotoDetailResponse: Codable {
    let id: String
    let imgUrl: String
    let sequence: Int
}

struct BallLogDeleteResponse: Codable {
    let code: String
    let message: String
}

private func formatDate(_ dateString: String) -> String {
    let inputFormatter = ISO8601DateFormatter()
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy/MM/dd"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    return dateString
}

// MARK: - Display Data Model
struct BallLogDisplayData {
    let id: Int


    let title: String
    let content: String
    let formattedDate: String
    let stadiumName: String
    let cheeringTeamName: String
    let opposingTeamName: String
    let scoreCheering: Int
    let scoreOpposing: Int
    let photos: [PhotoDetailResponse]
    let winRate: Double
    let isWin: Bool
    
    init(from data: BallLogDetailData) {
        self.id = data.id
        self.title = data.title
        self.content = data.content
        self.formattedDate = formatDate(data.matchDate)
        self.stadiumName = TeamSelectViewModel.getStadiumName(by: data.stadiumId)
        self.cheeringTeamName = TeamSelectViewModel.findTeamById(data.cheeringTeamId)?.name ?? "응원팀"
        self.opposingTeamName = TeamSelectViewModel.findTeamById(data.opposingTeamId)?.name ?? "상대팀"
        self.scoreCheering = data.scoreCheering
        self.scoreOpposing = data.scoreOpposing
        self.photos = data.photos
        self.winRate = data.winRate
        self.isWin = data.scoreCheering > data.scoreOpposing
    }
    
}
