//
//  TeamModels.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import Foundation

struct Team: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let shortName: String?
    let color: String?
    
    init(id: Int, name: String, shortName: String? = nil, color: String? = nil) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.color = color
    }
}

struct TeamSelectionRequest: Codable {
    let kboTeamId: Int
}

struct TeamSelectionResponse: Codable {
    let code: String
    let message: String
    let data: TeamSelectionData
}

struct TeamSelectionData: Codable {
    let kboTeamName: String
}
