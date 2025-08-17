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
    let matchResult: String
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
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy/MM/dd"
    outputFormatter.locale = Locale(identifier: "ko_KR")

    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
        return "날짜 변환 실패"
    }
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
        self.isWin = (data.matchResult == "WIN") ? true : false
    }
    
}
