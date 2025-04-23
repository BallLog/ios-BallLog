//
//  TeamData.swift
//  balllog
//
//  Created by 전은혜 on 4/20/25.
//

class TeamData {
    static let shared = TeamData()

    let teams: [[Team]] = [
        [Team(id: 1, name: "삼성 라이온즈"), Team(id: 3, name: "롯데 자이언츠")],
        [Team(id: 9, name: "SSG 랜더스"), Team(id: 2, name: "KIA 타이거즈")],
        [Team(id: 4, name: "LG 트윈스"), Team(id: 6, name: "두산 베어스")],
        [Team(id: 5, name: "한화 이글스"), Team(id: 10, name: "키움 히어로즈")],
        [Team(id: 7, name: "KT 위즈"), Team(id: 8, name: "NC 다이노스")]
    ]
}
