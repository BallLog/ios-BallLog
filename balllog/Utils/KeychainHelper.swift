//
//  KeychainHelper.swift
//  balllog
//
//  Created by 전은혜 on 6/24/25.
//
import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    // MARK: - 보안 데이터 (Keychain 저장)
    private enum SecureKeys {
       static let accessToken = "secure_access_token"
       static let refreshToken = "secure_refresh_token"
   }
       
    
    func save(_ value: String, for key: String) -> Bool {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // 기존 항목 삭제
        SecItemDelete(query as CFDictionary)
        
        // 새 항목 추가
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func get(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
       
        if status == errSecSuccess {
           if let data = dataTypeRef as? Data {
               return String(data: data, encoding: .utf8)
           }
        }
        return nil
    }
    
    func delete(for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    // MARK: - 토큰 관리 (보안 강화)
    func saveAccessToken(_ token: String) -> Bool {
        print("🔐 액세스 토큰을 Keychain에 저장")
        return save(token, for: SecureKeys.accessToken)
    }
    
    func getAccessToken() -> String? {
        return KeychainHelper.get(for: SecureKeys.accessToken)
    }
    
    func saveRefreshToken(_ token: String) -> Bool {
        print("🔐 리프레시 토큰을 Keychain에 저장")
        return save(token, for: SecureKeys.refreshToken)
    }
    
    func getRefreshToken() -> String? {
        return KeychainHelper.get(for: SecureKeys.refreshToken)
    }
    
    func clearAllTokens() -> Bool {
        print("🔐 모든 토큰을 Keychain에서 삭제")
        let accessDeleted = delete(for: SecureKeys.accessToken)
        let refreshDeleted = delete(for: SecureKeys.refreshToken)
        return accessDeleted && refreshDeleted
    }
}
