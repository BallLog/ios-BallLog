//
//  BallLogService.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import Foundation

protocol BallLogServiceProtocol {
    func fetchBallLogs(page: Int, size: Int, onlyWin: Bool?) async throws -> BallLogResponse
}

class BallLogService: BallLogServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager // 토큰 매니저 의존성
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }

    func fetchBallLogs(page: Int = 0, size: Int = 10, onlyWin: Bool? = nil) async throws -> BallLogResponse {
        var urlComponents = URLComponents(string: "\(baseURL)/ball-log")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        
        if let onlyWin = onlyWin {
            urlComponents.queryItems?.append(URLQueryItem(name: "onlyWin", value: "\(onlyWin)"))
        }
        
        print("📤 서버 요청 파라미터 - page: \(page), size: \(size), onlyWin: \(onlyWin?.description ?? "nil")")
        print("🌐 요청 URL: \(urlComponents.url?.absoluteString ?? "invalid URL")")
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Bearer 토큰 추가
        if let token = tokenManager.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("👉 JSON 데이터:\n\(jsonString)")
        }
        return try JSONDecoder().decode(BallLogResponse.self, from: data)
    }
}
