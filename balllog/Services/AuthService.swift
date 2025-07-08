//
//  AuthService.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

protocol AuthServiceProtocol {
    func kakaoLogin(accessToken: String) async throws -> LoginResponse
    func appleLogin(identityToken: String, authorizationCode: String?, email: String?, fullName: PersonNameComponents?) async throws -> LoginResponse
    func getUserProfile() async throws -> UserProfileResponse
}

class AuthService: AuthServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }
    
    func kakaoLogin(accessToken: String) async throws -> LoginResponse {
        print("🟡 카카오 로그인 API 호출 시작")
        
        guard let url = URL(string: "\(baseURL)/auth/sign-in/kakao") else {
            print("❌ 카카오 로그인 URL 생성 실패")
            throw AuthError.invalidURL
        }
        
        print("📡 카카오 로그인 URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(accessToken)", forHTTPHeaderField: "Authorization")
        
        print("🔑 카카오 액세스 토큰 설정 완료 (길이: \(accessToken.count))")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("📨 카카오 로그인 응답 받음")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ HTTP 응답이 아님")
                throw AuthError.invalidResponse
            }
            
            print("📊 카카오 로그인 응답 상태 코드: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 카카오 로그인 응답 내용: \(responseString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("❌ 카카오 로그인 서버 오류: \(httpResponse.statusCode)")
                throw AuthError.serverError(httpResponse.statusCode)
            }
            
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            print("✅ 카카오 로그인 응답 파싱 성공")
            return loginResponse
            
        } catch {
            print("❌ 카카오 로그인 네트워크 오류: \(error)")
            throw error
        }
    }
    
    func appleLogin(identityToken: String, authorizationCode: String?, email: String?, fullName: PersonNameComponents?) async throws -> LoginResponse {
        print("🍎 애플 로그인 API 호출 시작")
        
        guard let url = URL(string: "\(baseURL)/api/v1/auth/sign-in/apple") else {
            print("❌ 애플 로그인 URL 생성 실패")
            throw AuthError.invalidURL
        }
        
        print("📡 애플 로그인 URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(identityToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody = AppleLoginRequest(
            authorizationCode: authorizationCode,
            email: email,
            firstName: fullName?.givenName,
            lastName: fullName?.familyName
        )
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 애플 로그인 요청 JSON: \(jsonString)")
            }
        } catch {
            print("❌ 애플 로그인 JSON 인코딩 실패: \(error)")
            throw AuthError.encodingError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("📨 애플 로그인 응답 받음")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ HTTP 응답이 아님")
                throw AuthError.invalidResponse
            }
            
            print("📊 애플 로그인 응답 상태 코드: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 애플 로그인 응답 내용: \(responseString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("❌ 애플 로그인 서버 오류: \(httpResponse.statusCode)")
                throw AuthError.serverError(httpResponse.statusCode)
            }
            
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            print("✅ 애플 로그인 응답 파싱 성공")
            return loginResponse
            
        } catch {
            print("❌ 애플 로그인 네트워크 오류: \(error)")
            throw error
        }
    }
    
    func getUserProfile() async throws -> UserProfileResponse {
        print("👤 사용자 프로필 조회 API 호출 시작")
        
        guard let url = URL(string: "\(baseURL)/user/profile") else {
            print("❌ 프로필 조회 URL 생성 실패")
            throw AuthError.invalidURL
        }
        
        guard let accessToken = tokenManager.getAccessToken() else {
            print("❌ 액세스 토큰이 없음")
            throw AuthError.noAccessToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                if httpResponse.statusCode == 401 {
                    throw AuthError.tokenExpired
                }
                throw AuthError.serverError(httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(UserProfileResponse.self, from: data)
            
        } catch {
            print("❌ 프로필 조회 오류: \(error)")
            throw error
        }
    }
}

enum AuthError: Error, LocalizedError {
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
            return "데이터 인코딩 오류"
        case .noAccessToken:
            return "액세스 토큰이 없습니다."
        case .tokenExpired:
            return "토큰이 만료되었습니다."
        }
    }
}
