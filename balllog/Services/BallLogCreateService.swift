//
//  BallLogCreateService.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import Foundation

protocol BallLogCreateServiceProtocol {
    func createBallLog(_ request: BallLogCreateRequest) async throws -> BallLogCreateResponse
}

class BallLogCreateService: BallLogCreateServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }
    
    func createBallLog(_ request: BallLogCreateRequest) async throws -> BallLogCreateResponse {
        guard let url = URL(string: "\(baseURL)/ball-log") else {
            throw URLError(.badURL)
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Bearer 토큰 추가
        if let token = tokenManager.getAccessToken() {
            httpRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // JSON 인코딩
        do {
            let jsonData = try JSONEncoder().encode(request)
            httpRequest.httpBody = jsonData
            
            // 요청 JSON 출력
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 요청 JSON: \(jsonString)")
            }
            
        } catch {
            print("❌ JSON 인코딩 실패: \(error)")
            throw error
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: httpRequest)
            
            print("📨 API 응답 받음")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 API 응답 상태 코드: \(httpResponse.statusCode)")
                print("📋 API 응답 헤더: \(httpResponse.allHeaderFields)")
                
                // 응답 데이터를 문자열로 출력
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📄 API 응답 내용: \(responseString)")
                }
                
                if httpResponse.statusCode == 200 {
                    do {
                        let ballLogResponse = try JSONDecoder().decode(BallLogCreateResponse.self, from: data)
                        print("✅ 볼로그 생성 API 파싱 성공")
                        return ballLogResponse
                    } catch {
                        print("❌ 볼로그 생성 API JSON 파싱 실패: \(error)")
                        throw error
                    }
                } else {
                    print("❌ 볼로그 생성 API HTTP 오류: \(httpResponse.statusCode)")
                    
                    // 오류 응답도 파싱 시도
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("🔍 오류 응답 상세: \(errorString)")
                    }
                    
                    throw URLError(.badServerResponse)
                }
            } else {
                print("❌ 볼로그 생성 API HTTP 응답이 아님")
                throw URLError(.badServerResponse)
            }
            
        } catch {
            print("❌ 볼로그 생성 API 네트워크 오류: \(error)")
            throw error
        }
    }
}
