//
//  GlobalData.swift
//  balllog
//
//  Created by 전은혜 on 5/15/25.
//
import Foundation
import SwiftUI

class GlobalData: ObservableObject {
    static let shared = GlobalData()
    
    @Published var selectedTeam: Team?
    @Published var winCount: Int = 0
    @Published var totalGames: Int = 0
    
    private init() {
        loadData()
    }
    
    var winRate: Double {
        totalGames == 0 ? 0 : Double(winCount) / Double(totalGames)
    }
    
    var myTeamName: String {
        selectedTeam?.name ?? ""
    }
    var myTeamKey: String {
        selectedTeam?.key ?? ""
    }
    
    func setMyTeam(_ team: Team) {
        selectedTeam = team
        saveData()
    }
    
    private func loadData() {
        // 저장된 팀 ID로 팀 찾기
        let savedTeamId = UserDefaults.standard.integer(forKey: "selectedTeamId")
        if savedTeamId > 0 {
            selectedTeam = TeamData.shared.findIdTeam(by: savedTeamId)
        }
        
        winCount = UserDefaults.standard.integer(forKey: "winCount")
        totalGames = UserDefaults.standard.integer(forKey: "totalGames")
    }
    
    private func saveData() {
        if let teamId = selectedTeam?.id {
            UserDefaults.standard.set(teamId, forKey: "selectedTeamId")
        }
        UserDefaults.standard.set(winCount, forKey: "winCount")
        UserDefaults.standard.set(totalGames, forKey: "totalGames")
    }
}

// 사용법
// @StateObject private var globalData = GlobalData.shared
