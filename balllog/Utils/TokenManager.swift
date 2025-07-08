//
//  TokenManager.swift
//  balllog
//
//  Created by 전은혜 on 6/24/25.
//
import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let keychain = KeychainHelper.shared
    private let preferences = UserPreferences.shared
    private init() {}
    
    // MARK: - 토큰 저장 (보안 강화)
    func saveUserTokens(accessToken: String, refreshToken: String) {
        print("🔐 사용자 토큰 저장 시작")
        
        let accessSaved = keychain.saveAccessToken(accessToken)
        let refreshSaved = keychain.saveRefreshToken(refreshToken)
        
        if accessSaved && refreshSaved {
            print("✅ 모든 토큰이 Keychain에 안전하게 저장됨")
        } else {
            print("❌ 토큰 저장 실패")
        }
    }
    
    func saveTokenExpirationTimes(accessTokenExpiry: Int64, refreshTokenExpiry: Int64) {
        print("📱 토큰 만료 시간 저장")
        preferences.setTokenExpirationTimes(
            accessTokenExpiry: accessTokenExpiry,
            refreshTokenExpiry: refreshTokenExpiry
        )
    }
    
    // MARK: - 토큰 조회 (보안 강화)
    func getAccessToken() -> String? {
        return keychain.getAccessToken()
    }
    
    func getRefreshToken() -> String? {
        return keychain.getRefreshToken()
    }
    
    // MARK: - 토큰 유효성 검사
    func isTokenValid() -> Bool {
        guard let _ = getAccessToken() else {
            print("❌ 액세스 토큰이 없음")
            return false
        }
        
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000)
        let expiryTime = preferences.getAccessTokenExpiry()

        if currentTime < expiryTime {
            print("✅ 토큰이 유효함")
            return true
        } else {
            print("❌ 토큰이 만료됨")
            return false
        }
    }
    
    // MARK: - 토큰 삭제 (보안 강화)
    func clearTokens() {
        print("🗑 모든 토큰 삭제 시작")
        
        let keychainCleared = keychain.clearAllTokens()
        preferences.clearAllUserData()
        
        if keychainCleared {
            print("✅ 모든 토큰과 사용자 데이터 삭제 완료")
        } else {
            print("❌ 토큰 삭제 실패")
        }
    }
}
