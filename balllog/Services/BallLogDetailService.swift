//
//  BallLogDetailService.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//


import Foundation

protocol BallLogDetailServiceProtocol {
    func getBallLogDetail(id: String) async throws -> BallLogDetailResponse
    func deleteBallLog(id: String) async throws -> BallLogDeleteResponse
}

class BallLogDetailService: BallLogDetailServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }
    
    func getBallLogDetail(id: String) async throws -> BallLogDetailResponse {
        print("📡 볼로그 상세 조회 API 호출: \(id)")
        
        guard let url = URL(string: "\(baseURL)/ball-log/\(id)") else {
            print("❌ 볼로그 상세 조회 URL 생성 실패")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Bearer 토큰 추가
        if let token = tokenManager.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            print("📊 볼로그 상세 조회 응답 상태: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 볼로그 상세 조회 응답: \(responseString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            
            let detailResponse = try JSONDecoder().decode(BallLogDetailResponse.self, from: data)
            print("✅ 볼로그 상세 조회 파싱 성공")
            return detailResponse
            
        } catch {
            print("❌ 볼로그 상세 조회 API 오류: \(error)")
            throw error
        }
    }
    
    func deleteBallLog(id: String) async throws -> BallLogDeleteResponse {
        print("🗑 볼로그 삭제 API 호출: \(id)")
        
        guard let url = URL(string: "\(baseURL)/ball-log/\(id)") else {
            print("❌ 볼로그 삭제 URL 생성 실패")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Bearer 토큰 추가
        if let token = tokenManager.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            print("📊 볼로그 삭제 응답 상태: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 볼로그 삭제 응답: \(responseString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            
            let deleteResponse = try JSONDecoder().decode(BallLogDeleteResponse.self, from: data)
            print("✅ 볼로그 삭제 성공")
            return deleteResponse
            
        } catch {
            print("❌ 볼로그 삭제 API 오류: \(error)")
            throw error
        }
    }
}
