//
//  MyPageService.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation

struct MyPageResponse: Codable {
    let code: String
    let message: String
    let data: MyPageData
}

struct MyPageData: Codable {
    let id: Int
    let cheeringTeamId: Int
    let name: String
    let winRate: Int
}


protocol MyPageServiceProtocol {
    func getMyPageProfile() async throws -> MyPageProfile
    func logout() async throws
    func withdrawUser(reason: String?) async throws -> WithdrawalResponse
}

class MyPageService: MyPageServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }
    
    func getMyPageProfile() async throws -> MyPageProfile {
        print("👤 마이페이지 프로필 조회 시작")
        
        guard let url = URL(string: "\(baseURL)/user/mypage-info") else {
            print("❌ 마이페이지 프로필 조회 URL 생성 실패")
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
            
            print("📊 마이페이지 조회 응답 상태: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 마이페이지 조회 응답: \(responseString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            
            let detailResponse = try JSONDecoder().decode(MyPageResponse.self, from: data)
            print("✅ 볼로그 상세 조회 파싱 성공")
            
            // 로컬 데이터에서 프로필 생성
            let preferences = UserPreferences.shared
            
            let teamName = TeamSelectViewModel.findTeamById(detailResponse.data.cheeringTeamId)?.name ?? ""
            
            preferences.setTeamName(teamName)
            
            let profile = MyPageProfile(
                id: detailResponse.data.id,
                cheeringTeamId: detailResponse.data.cheeringTeamId,
                teamName: teamName,
                name: detailResponse.data.name,
                winRate: detailResponse.data.winRate,
                winGames: preferences.winGames,
                totalGames: preferences.totalGames
            )
            
            print("✅ 마이페이지 프로필 조회 완료: \(profile.name), \(profile.teamName)")
            
            return profile
            
        } catch {
            print("❌ 마이페이지 조회 API 오류: \(error)")
            throw error
        }
        
    }
    
    func logout() async throws {
        print("🚪 로그아웃 API 호출 시작")
        
        guard let url = URL(string: "\(baseURL)/auth/logout") else {
            print("❌ 로그아웃 URL 생성 실패")
            throw MyPageError.invalidURL
        }
        
        guard let accessToken = tokenManager.getAccessToken() else {
            print("❌ 액세스 토큰이 없음")
            throw MyPageError.noAccessToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 로그아웃 응답 상태 코드: \(httpResponse.statusCode)")
                
                if 200...299 ~= httpResponse.statusCode {
                    print("✅ 서버 로그아웃 성공")
                } else {
                    print("⚠️ 서버 로그아웃 실패하지만 로컬 로그아웃 진행")
                }
            }
        } catch {
            print("❌ 로그아웃 API 오류: \(error)")
            // 네트워크 오류가 있어도 로컬 로그아웃은 진행
        }
    }
    
    func withdrawUser(reason: String?) async throws -> WithdrawalResponse {
        print("🗑 회원탈퇴 API 호출 시작")
        
        guard let url = URL(string: "\(baseURL)/user/withdraw") else {
            print("❌ 회원탈퇴 URL 생성 실패")
            throw MyPageError.invalidURL
        }
        
        guard let accessToken = tokenManager.getAccessToken() else {
            print("❌ 액세스 토큰이 없음")
            throw MyPageError.noAccessToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // 탈퇴 사유가 있으면 body에 포함
        if let reason = reason, !reason.isEmpty {
            let withdrawalRequest = WithdrawalRequest(reason: reason)
            do {
                let jsonData = try JSONEncoder().encode(withdrawalRequest)
                request.httpBody = jsonData
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("📤 회원탈퇴 요청 JSON: \(jsonString)")
                }
            } catch {
                print("❌ JSON 인코딩 실패: \(error)")
                throw MyPageError.encodingError
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw MyPageError.invalidResponse
            }
            
            print("📊 회원탈퇴 응답 상태 코드: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 회원탈퇴 응답 내용: \(responseString)")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw MyPageError.serverError(httpResponse.statusCode)
            }
            
            let withdrawalResponse = try JSONDecoder().decode(WithdrawalResponse.self, from: data)
            print("✅ 회원탈퇴 성공")
            return withdrawalResponse
            
        } catch {
            print("❌ 회원탈퇴 API 오류: \(error)")
            throw error
        }
    }
}

enum MyPageError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case encodingError
    case noAccessToken
    
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
        }
    }
}
