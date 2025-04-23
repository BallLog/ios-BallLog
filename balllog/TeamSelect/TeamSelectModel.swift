//
//  TeamSelectModel.swift
//  balllog
//
//  Created by 전은혜 on 4/20/25.
//

import Foundation

struct TeamSelectionResponse: Decodable {
    let code: String
    let message: String
    let data: TeamSelectData
}

struct TeamSelectData: Decodable {
    let userId: Int
    let kboTeamId: Int
    let kboTeamName: String
}
