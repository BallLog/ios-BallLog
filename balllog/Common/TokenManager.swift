//
//  TokenManager.swift
//  balllog
//
//  Created by 전은혜 on 6/24/25.
//
import Foundation

class TokenManager {
    static let shared = TokenManager()
    private init() {}
    
    // MARK: - 토큰 저장 함수들
    func saveUserTokens(accessToken: String, refreshToken: String) {
        KeychainHelper.save(accessToken, for: "access_token")
        KeychainHelper.save(refreshToken, for: "refresh_token")
    }
    
    func saveTokenExpirationTimes(accessTokenExpiry: Int64, refreshTokenExpiry: Int64) {
        UserDefaults.standard.set(accessTokenExpiry, forKey: "access_token_expiry")
        UserDefaults.standard.set(refreshTokenExpiry, forKey: "refresh_token_expiry")
    }
    
    // 액세스 토큰 가져오기
    func getAccessToken() -> String? {
        return KeychainHelper.get(for: "access_token")
    }
    
    // 리프레시 토큰 가져오기
    func getRefreshToken() -> String? {
        return KeychainHelper.get(for: "refresh_token")
    }
    
    // 토큰 만료 시간 확인
    func isAccessTokenExpired() -> Bool {
        let expiryTime = UserDefaults.standard.object(forKey: "access_token_expiry") as? Int64 ?? 0
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000) // 밀리초
        return currentTime >= expiryTime
    }
    
    // 토큰 유효성 검사
    func isTokenValid() -> Bool {
        guard getAccessToken() != nil else { return false }
        return !isAccessTokenExpired()
    }
    
    // 토큰 삭제 (로그아웃 시)
    func clearTokens() {
        KeychainHelper.delete(for: "access_token")
        KeychainHelper.delete(for: "refresh_token")
        UserDefaults.standard.removeObject(forKey: "access_token_expiry")
        UserDefaults.standard.removeObject(forKey: "refresh_token_expiry")
    }
}
