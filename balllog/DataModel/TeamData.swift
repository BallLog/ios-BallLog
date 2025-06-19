//
//  TeamData.swift
//  balllog
//
//  Created by 전은혜 on 4/20/25.
//

struct Team: Identifiable, Hashable {
    let id: Int
    let name: String
    let key: String
}


class TeamData {
    static let shared = TeamData()
    
    let teams: [[Team]] = [
        [Team(id: 1, name: "삼성 라이온즈", key: "LIONS"), Team(id: 3, name: "롯데 자이언츠", key: "GIANTS")],
        [Team(id: 9, name: "SSG 랜더스", key: "LANDERS"), Team(id: 2, name: "KIA 타이거즈", key:"TIGERS")],
        [Team(id: 4, name: "LG 트윈스", key:"TWINS"), Team(id: 6, name: "두산 베어스", key: "BEARS")],
        [Team(id: 5, name: "한화 이글스", key: "EAGLES"), Team(id: 10, name: "키움 히어로즈", key: "HEROES")],
        [Team(id: 7, name: "KT 위즈", key: "WIZ"), Team(id: 8, name: "NC 다이노스", key: "DINOS")]
    ]
    
    // 모든 팀을 1차원 배열로 반환
    var allTeams: [Team] {
        teams.flatMap { $0 }
    }
    
    // ID로 팀 찾기
    func findIdTeam(by id: Int) -> Team? {
        allTeams.first { $0.id == id }
    }
    
    // 이름으로 팀 찾기
    func findNameTeam(by name: String) -> Team? {
        allTeams.first { $0.name == name }
    }
    
    // 키로 팀 찾기
    func findKeyTeam(by key: String) -> Team? {
        allTeams.first { $0.key == key }
    }
}
