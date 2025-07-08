//
//  UserPreferences.swift
//  balllog
//
//  Created by 전은혜 on 6/24/25.
//

import Foundation
import SwiftUI

class UserPreferences: ObservableObject {
    static let shared = UserPreferences()
    
    private init() {
        initializeWinRateData()
    }
    
    // MARK: - 민감하지 않은 데이터 (UserDefaults 저장)
    private enum Keys {
        static let selectedTeam = "selected_team"
        static let accessTokenExpiry = "access_token_expiry"
        static let refreshTokenExpiry = "refresh_token_expiry"
        static let localWinRate = "local_win_rate"
        static let lastSyncDate = "last_sync_date"
        static let totalGames = "total_games"
        static let winGames = "win_games"
    }
    
    // MARK: - 팀 관리
    func setTeamName(_ teamName: String) {
        print("📱 팀 이름을 UserDefaults에 저장: \(teamName)")
        UserDefaults.standard.set(teamName, forKey: "selected_team")
    }
    
    func getTeamName() -> String {
        return UserDefaults.standard.string(forKey: "selected_team") ?? "삼성 라이온즈"
    }
    
    // MARK: - 토큰 만료 시간 관리
    func setTokenExpirationTimes(accessTokenExpiry: Int64, refreshTokenExpiry: Int64) {
        print("📱 토큰 만료 시간을 UserDefaults에 저장")
        UserDefaults.standard.set(accessTokenExpiry, forKey: Keys.accessTokenExpiry)
        UserDefaults.standard.set(refreshTokenExpiry, forKey: Keys.refreshTokenExpiry)
    }
    
    func getAccessTokenExpiry() -> Int64 {
        return UserDefaults.standard.object(forKey: Keys.accessTokenExpiry) as? Int64 ?? 0
    }
    
    func getRefreshTokenExpiry() -> Int64 {
        return UserDefaults.standard.object(forKey: Keys.refreshTokenExpiry) as? Int64 ?? 0
    }
    
    // MARK: - 승률 관리 (로컬 캐시)
    @Published var localWinRate: Double = 0.0
    @Published var totalGames: Int = 0
    @Published var winGames: Int = 0
    
    func initializeWinRateData() {
        localWinRate = UserDefaults.standard.double(forKey: Keys.localWinRate)
        totalGames = UserDefaults.standard.integer(forKey: Keys.totalGames)
        winGames = UserDefaults.standard.integer(forKey: Keys.winGames)
        
        print("📊 승률 데이터 초기화: \(winGames)/\(totalGames) = \(localWinRate)%")
    }
    
    func updateLocalWinRate(isWin: Bool) {
        print("📊 로컬 승률 업데이트 시작 (승리: \(isWin))")
        
        // 게임 수 증가
        totalGames += 1
        if isWin {
            winGames += 1
        }
        
        // 승률 계산
        localWinRate = totalGames > 0 ? (Double(winGames) / Double(totalGames)) * 100 : 0.0
        
        // UserDefaults에 저장
        UserDefaults.standard.set(localWinRate, forKey: Keys.localWinRate)
        UserDefaults.standard.set(totalGames, forKey: Keys.totalGames)
        UserDefaults.standard.set(winGames, forKey: Keys.winGames)
        
        print("📊 로컬 승률 업데이트 완료: \(winGames)/\(totalGames) = \(String(format: "%.1f", localWinRate))%")
    }
    
    func syncWinRateFromServer(serverWinRate: Double, serverTotalGames: Int, serverWinGames: Int) {
        print("🔄 서버 승률로 동기화: \(serverWinGames)/\(serverTotalGames) = \(serverWinRate)%")
        
        localWinRate = serverWinRate
        totalGames = serverTotalGames
        winGames = serverWinGames
        
        // UserDefaults에 저장
        UserDefaults.standard.set(localWinRate, forKey: Keys.localWinRate)
        UserDefaults.standard.set(totalGames, forKey: Keys.totalGames)
        UserDefaults.standard.set(winGames, forKey: Keys.winGames)
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: Keys.lastSyncDate)
        
        print("✅ 서버 승률 동기화 완료")
    }
    
    func getLastSyncDate() -> Date? {
        let timestamp = UserDefaults.standard.double(forKey: Keys.lastSyncDate)
        return timestamp > 0 ? Date(timeIntervalSince1970: timestamp) : nil
    }
    
    // MARK: - 데이터 초기화
    func clearAllUserData() {
        print("🗑 모든 사용자 데이터 삭제")
        
        let keys = [Keys.selectedTeam, Keys.accessTokenExpiry, Keys.refreshTokenExpiry,
                   Keys.localWinRate, Keys.lastSyncDate, Keys.totalGames, Keys.winGames]
        
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        // Published 프로퍼티 초기화
        localWinRate = 0.0
        totalGames = 0
        winGames = 0
    }
}
