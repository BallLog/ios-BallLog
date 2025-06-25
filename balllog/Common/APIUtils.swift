//
//  APIUtils.swift
//  balllog
//
//  Created by Nada on 4/20/25.
//

import Foundation


struct LoginResponse: Codable {
    let data: LoginData?
    let code: String
    let message: String
}

struct LoginData: Codable {
    let status: String
    let tokenInfo: TokenInfo
}

struct TokenInfo: Codable {
    let grantType: String
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiresIn: Int64
    let refreshTokenExpiresIn: Int64
}

// 팀 선택 요청 모델
struct TeamSelectionRequest: Codable {
    let kboTeamId: Int
}

class APIUtils {
    static let shared = APIUtils()
    private init() {}
    
    static func getApiUrl() -> String? {
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            return nil
        }
        return apiUrl
    }
    
    func kakaoLogin(accessToken: String) async throws -> LoginResponse {
        guard let baseUrl = APIUtils.getApiUrl(),
              let url = URL(string: "\(baseUrl)/auth/sign-in/kakao") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Bearer 접두사 추가!
        request.setValue("\(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(LoginResponse.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        }
    }
    
    // Apple 로그인 API 호출
    func appleLogin(identityToken: String, authorizationCode: String?, email: String?, fullName: PersonNameComponents?) async throws -> LoginResponse {
        print("🍎 Starting Apple Login API call...")
        
        guard let baseUrl = APIUtils.getApiUrl(),
              let url = URL(string: "\(baseUrl)/api/v1/auth/sign-in/apple") else {
            print("❌ Invalid URL for Apple login")
            throw APIError.invalidURL
        }
        
        print("🌐 Apple Login URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Apple Identity Token을 Authorization 헤더에 포함
        request.setValue("Bearer \(identityToken)", forHTTPHeaderField: "Authorization")
        
        // 추가 정보가 있다면 body에 포함 (서버 명세에 따라 조정 필요)
        let requestBody = AppleLoginRequest(
            authorizationCode: authorizationCode,
            email: email,
            firstName: fullName?.givenName,
            lastName: fullName?.familyName
        )
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(requestBody)
            
            if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 Request Body: \(bodyString)")
            }
        } catch {
            print("❌ Failed to encode request body: \(error)")
            throw APIError.encodingError
        }
        
        print("📋 Request Headers:")
        request.allHTTPHeaderFields?.forEach { key, value in
            if key == "Authorization" {
                print("  \(key): Bearer \(String(value.dropFirst(7).prefix(20)))...")
            } else {
                print("  \(key): \(value)")
            }
        }
        
        do {
            print("⏳ Sending Apple login request...")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response")
                throw APIError.invalidResponse
            }
            
            print("📊 Apple Login Status Code: \(httpResponse.statusCode)")
            
            // 응답 데이터 출력
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Apple Login Response: \(jsonString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("❌ Apple login server error: \(httpResponse.statusCode)")
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            print("✅ Apple login response decoded successfully")
            return loginResponse
            
        } catch {
            print("❌ Apple login network error: \(error)")
            throw error
        }
    }
    
    // 새로 추가할 메소드들
    private func createAuthenticatedRequest(url: URL, method: String = "GET") throws -> URLRequest {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            throw APIError.noAccessToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    // 사용자 프로필 조회
    func getUserProfile() async throws -> UserProfileResponse {
        guard let baseUrl = APIUtils.getApiUrl(),
              let url = URL(string: "\(baseUrl)/user/profile") else {
            throw APIError.invalidURL
        }
        
        let request = try createAuthenticatedRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            if httpResponse.statusCode == 401 {
                throw APIError.tokenExpired
            }
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(UserProfileResponse.self, from: data)
    }
    
    // 팀 정하기
    func selectTeam(teamId: Int) async throws -> TeamSelectionResponse {
        guard let baseUrl = APIUtils.getApiUrl(),
              let url = URL(string: "\(baseUrl)/user/my-kbo-team") else {
            throw APIError.invalidURL
        }
        
        var request = try createAuthenticatedRequest(url: url, method: "POST")
        
        let requestBody = TeamSelectionRequest(kboTeamId: teamId)
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            if httpResponse.statusCode == 401 {
                throw APIError.tokenExpired
            }
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(TeamSelectionResponse.self, from: data)
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
    case encodingError
    case noAccessToken
    case tokenExpired
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidResponse:
            return "서버 응답이 올바르지 않습니다."
        case .serverError(let code):
            return "서버 오류 (코드: \(code))"
        case .decodingError:
            return "데이터 파싱 오류"
        case .encodingError:
            return "데이터 인코딩 오료"
        case .noAccessToken:
            return "액세스 토큰이 없습니다."
        case .tokenExpired:
            return "토큰이 만료되었습니다."
        }
    }
}
