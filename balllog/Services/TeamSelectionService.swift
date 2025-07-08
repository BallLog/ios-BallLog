//
//  TeamSelectionService.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import Foundation

protocol TeamSelectionServiceProtocol {
    func selectTeam(teamId: Int) async throws -> TeamSelectionResponse
}

class TeamSelectionService: TeamSelectionServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }
    
    func selectTeam(teamId: Int) async throws -> TeamSelectionResponse {
        print("🏈 팀 선택 API 호출 시작")
        print("📤 선택된 팀 ID: \(teamId)")
        
        guard let url = URL(string: "\(baseURL)/user/my-kbo-team") else {
            print("❌ API URL 생성 실패")
            throw URLError(.badURL)
        }
        
        print("📡 API URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Bearer 토큰 추가
        if let token = tokenManager.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔑 토큰 설정 완료 (길이: \(token.count))")
        } else {
            print("⚠️ 토큰이 없습니다!")
        }
        
        // JSON 인코딩
        do {
            let requestBody = TeamSelectionRequest(kboTeamId: teamId)
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 요청 JSON: \(jsonString)")
            }
        } catch {
            print("❌ JSON 인코딩 실패: \(error)")
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("📨 팀 선택 API 응답 받음")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 응답 상태 코드: \(httpResponse.statusCode)")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📄 응답 내용: \(responseString)")
                }
                
                if httpResponse.statusCode == 200 {
                    do {
                        let teamResponse = try JSONDecoder().decode(TeamSelectionResponse.self, from: data)
                        print("✅ 팀 선택 API 파싱 성공")
                        return teamResponse
                    } catch {
                        print("❌ JSON 파싱 실패: \(error)")
                        throw error
                    }
                } else {
                    print("❌ HTTP 오류: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            } else {
                print("❌ HTTP 응답이 아님")
                throw URLError(.badServerResponse)
            }
        } catch {
            print("❌ 네트워크 오류: \(error)")
            throw error
        }
    }
}
