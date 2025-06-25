//
//  UserPreferences.swift
//  balllog
//
//  Created by 전은혜 on 6/24/25.
//

import Foundation

class UserPreferences {
    static let shared = UserPreferences()
    private init() {}
    
    // 팀 이름 저장
    func saveTeamName(_ teamName: String) {
        UserDefaults.standard.set(teamName, forKey: "teamName")
    }
    
    // 팀 이름 가져오기
    func getTeamName() -> String? {
        return UserDefaults.standard.string(forKey: "teamName")
    }
    
    // 팀이 선택되었는지 확인
    func hasSelectedTeam() -> Bool {
        return getTeamName() != nil
    }
    
    // 팀 정보 삭제 (로그아웃 시)
    func clearTeamInfo() {
        UserDefaults.standard.removeObject(forKey: "teamName")
    }
}
