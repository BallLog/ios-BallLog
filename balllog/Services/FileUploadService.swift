//
//  FileUploadService.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import Foundation

protocol FileUploadServiceProtocol {
    func getPresignedUrl(fileName: String) async throws -> PresignedUrlResponse
    func uploadFile(to presignedUrl: String, data: Data) async throws
}

class FileUploadService: FileUploadServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }
    
    func getPresignedUrl(fileName: String) async throws -> PresignedUrlResponse {
        print("🔗 Presigned URL 요청 시작: \(fileName)")
        
        var urlComponents = URLComponents(string: "\(baseURL)/file/presigned-url")!
        urlComponents.queryItems = [
            URLQueryItem(name: "fileName", value: fileName)
        ]
        
        guard let url = urlComponents.url else {
            print("❌ URL 생성 실패")
            throw URLError(.badURL)
        }
        print("📡 요청 URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Bearer 토큰 추가
        if let token = tokenManager.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔑 토큰 설정 완료 (길이: \(token.count))")
        } else {
            print("⚠️ 토큰이 없습니다!")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("📨 응답 받음")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 응답 상태 코드: \(httpResponse.statusCode)")
                print("📋 응답 헤더: \(httpResponse.allHeaderFields)")
                
                // 응답 데이터를 문자열로 출력
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📄 응답 내용: \(responseString)")
                }
                
                if httpResponse.statusCode == 200 {
                    do {
                        let presignedResponse = try JSONDecoder().decode(PresignedUrlResponse.self, from: data)
                        print("✅ Presigned URL 파싱 성공")
                        return presignedResponse
                    } catch {
                        print("❌ JSON 파싱 실패: \(error)")
                        throw error
                    }
                } else {
                    print("❌ HTTP 오류 응답: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            } else {
                print("❌ HTTP 응답이 아님")
                throw URLError(.badServerResponse)
            }
            
        } catch {
            print("❌ 네트워크 요청 실패: \(error)")
            throw error
        }
    }
    
    func uploadFile(to presignedUrl: String, data: Data) async throws {
        print("☁️ S3 업로드 시작")
        print("📡 업로드 URL: \(presignedUrl.prefix(100))...")
        print("📦 데이터 크기: \(data.count) bytes")
         
        guard let url = URL(string: presignedUrl) else {
            print("❌ Presigned URL이 유효하지 않음")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        
        // Content-Type 설정
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        print("📋 Content-Type 설정: image/jpeg")
        
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 S3 응답 상태 코드: \(httpResponse.statusCode)")
                print("📋 S3 응답 헤더: \(httpResponse.allHeaderFields)")
                
                // S3 응답 내용 출력 (있는 경우)
                if !responseData.isEmpty {
                    if let responseString = String(data: responseData, encoding: .utf8) {
                        print("📄 S3 응답 내용: \(responseString)")
                    }
                }
                
                // S3는 보통 200 또는 204 반환
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                    print("✅ S3 업로드 성공")
                } else {
                    print("❌ S3 업로드 실패: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            } else {
                print("❌ S3 HTTP 응답이 아님")
                throw URLError(.badServerResponse)
            }
            
        } catch {
            print("❌ S3 업로드 네트워크 오류: \(error)")
            throw error
        }
    }
}
