//
//  NicknameService.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation

protocol NicknameServiceProtocol {
    func checkNicknameAvailability(_ nickname: String) async throws -> NicknameCheckResponse
    func updateNickname(_ nickname: String) async throws -> NicknameUpdateResponse
    func saveNicknameLocally(_ nickname: String)
    func getSavedNickname() -> String?
}

class NicknameService: NicknameServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }
    
    func checkNicknameAvailability(_ nickname: String) async throws -> NicknameCheckResponse {
        print("🔍 닉네임 중복 확인 API 호출: \(nickname)")
        
        guard let url = URL(string: "\(baseURL)/user/nickname/check") else {
            print("❌ 닉네임 확인 URL 생성 실패")
            throw NicknameError.invalidURL
        }
        
        guard let accessToken = tokenManager.getAccessToken() else {
            print("❌ 액세스 토큰이 없음")
            throw NicknameError.noAccessToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody = NicknameCheckRequest(name: nickname)
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 닉네임 확인 요청: \(jsonString)")
            }
        } catch {
            print("❌ JSON 인코딩 실패: \(error)")
            throw NicknameError.encodingError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NicknameError.invalidResponse
            }
            
            print("📊 닉네임 확인 응답 상태 코드: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 닉네임 확인 응답: \(responseString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NicknameError.serverError(httpResponse.statusCode)
            }
            
            let nicknameResponse = try JSONDecoder().decode(NicknameCheckResponse.self, from: data)
            print("✅ 닉네임 확인 완료")
            return nicknameResponse
            
        } catch {
            print("❌ 닉네임 확인 API 오류: \(error)")
            throw error
        }
    }
    
    func updateNickname(_ nickname: String) async throws -> NicknameUpdateResponse {
        print("✏️ 닉네임 업데이트 API 호출: \(nickname)")
        
        guard let url = URL(string: "\(baseURL)/user/nickname") else {
            print("❌ 닉네임 업데이트 URL 생성 실패")
            throw NicknameError.invalidURL
        }
        
        guard let accessToken = tokenManager.getAccessToken() else {
            print("❌ 액세스 토큰이 없음")
            throw NicknameError.noAccessToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody = NicknameUpdateRequest(name: nickname)
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 닉네임 업데이트 요청: \(jsonString)")
            }
        } catch {
            print("❌ JSON 인코딩 실패: \(error)")
            throw NicknameError.encodingError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NicknameError.invalidResponse
            }
            
            print("📊 닉네임 업데이트 응답 상태 코드: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 닉네임 업데이트 응답: \(responseString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NicknameError.serverError(httpResponse.statusCode)
            }
            
            let updateResponse = try JSONDecoder().decode(NicknameUpdateResponse.self, from: data)
            print("✅ 닉네임 업데이트 완료")
            
            // 로컬에도 저장
            saveNicknameLocally(nickname)
            
            return updateResponse
            
        } catch {
            print("❌ 닉네임 업데이트 API 오류: \(error)")
            throw error
        }
    }
    
    func saveNicknameLocally(_ name: String) {
        UserDefaults.standard.set(name, forKey: "user_name")
        print("💾 닉네임 로컬 저장: \(name)")
    }
    
    func getSavedNickname() -> String? {
        return UserDefaults.standard.string(forKey: "user_name")
    }
}

enum NicknameError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case encodingError
    case noAccessToken
    case validationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidResponse:
            return "서버 응답이 올바르지 않습니다."
        case .serverError(let code):
            return "서버 오류 (코드: \(code))"
        case .encodingError:
            return "데이터 인코딩 오류"
        case .noAccessToken:
            return "액세스 토큰이 없습니다."
        case .validationFailed(let message):
            return message
        }
    }
}
