//
//  BallLogCreateViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class BallLogCreateViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title: String = ""
    @Published var gameDate: Date?
    @Published var stadium: String = ""
    @Published var myTeam: String = ""
    @Published var myTeamScore: String = "0"
    @Published var opposingTeam: String = ""
    @Published var opposingTeamScore: String = "0"
    @Published var photoList: [PhotosPickerItem] = []
    @Published var logContent: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSuccessful = false
    @Published var showExitConfirmation = false
    
    // MARK: - Computed Properties
    var hasAnyInput: Bool {
        !title.isEmpty ||
        gameDate != nil ||
        !stadium.isEmpty ||
        !myTeam.isEmpty ||
        !myTeamScore.isEmpty ||
        !opposingTeam.isEmpty ||
        !opposingTeamScore.isEmpty ||
        !photoList.isEmpty ||
        !logContent.isEmpty
    }
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !logContent.trimmingCharacters(in: .whitespaces).isEmpty &&
        !myTeam.isEmpty &&
        !opposingTeam.isEmpty &&
        !myTeamScore.isEmpty &&
        !opposingTeamScore.isEmpty &&
        !stadium.isEmpty &&
        myTeam != opposingTeam
    }
    
    // MARK: - Private Properties
    private let createService: BallLogCreateServiceProtocol
    private let fileUploadService: FileUploadServiceProtocol
    
    // MARK: - Static Data
    private let teamInfoList: [TeamInfo] = [
        TeamInfo(id: 1, name: "기아 타이거즈"),
        TeamInfo(id: 2, name: "삼성 라이온즈"),
        TeamInfo(id: 3, name: "LG 트윈스"),
        TeamInfo(id: 4, name: "두산 베어스"),
        TeamInfo(id: 5, name: "KT 위즈"),
        TeamInfo(id: 6, name: "SSG 랜더스"),
        TeamInfo(id: 7, name: "롯데 자이언츠"),
        TeamInfo(id: 8, name: "한화 이글스"),
        TeamInfo(id: 9, name: "NC 다이노스"),
        TeamInfo(id: 10, name: "키움 히어로즈")
    ]
    
    private let stadiumInfoList: [StadiumInfo] = [
        StadiumInfo(id: 1, name: "광주-기아 챔피언스 필드"),
        StadiumInfo(id: 2, name: "대구 삼성 라이온즈 파크"),
        StadiumInfo(id: 3, name: "서울 종합운동장 야구장"),
        StadiumInfo(id: 4, name: "수원 케이티 위즈 파크"),
        StadiumInfo(id: 5, name: "사직 야구장"),
        StadiumInfo(id: 6, name: "대전 한화생명 볼파크"),
        StadiumInfo(id: 7, name: "고척 스카이돔"),
        StadiumInfo(id: 8, name: "창원 NC파크"),
        StadiumInfo(id: 9, name: "인천 SSG 랜더스 필드"),
        StadiumInfo(id: 10, name: "기타 (제 2구장 등)")
    ]
    
    // MARK: - Initialization
    init(createService: BallLogCreateServiceProtocol = BallLogCreateService(),
         fileUploadService: FileUploadServiceProtocol = FileUploadService()) {
        self.createService = createService
        self.fileUploadService = fileUploadService
    }
    
    // 볼로그 생성 성공 시 승률 업데이트
    private func updateWinRateAfterLogCreation() {
        guard let cheeringScore = Int(myTeamScore),
              let opposingScore = Int(opposingTeamScore) else {
            return
        }
        
        let isWin = cheeringScore > opposingScore
        
        // 1. 로컬 승률 즉시 업데이트 (빠른 UI 반응)
        UserPreferences.shared.updateLocalWinRate(isWin: isWin)
        
        // 2. 백그라운드에서 서버 동기화 (나중에 구현)
        Task {
            await syncWinRateWithServer()
        }
    }
    
    private func syncWinRateWithServer() async {
        // TODO: 서버에서 최신 승률 데이터 가져오기
        // 예시:
        // do {
        //     let winRateResponse = try await winRateService.getWinRate()
        //     await MainActor.run {
        //         UserPreferences.shared.syncWinRateFromServer(
        //             serverWinRate: winRateResponse.winRate,
        //             serverTotalGames: winRateResponse.totalGames,
        //             serverWinGames: winRateResponse.winGames
        //         )
        //     }
        // } catch {
        //     print("❌ 승률 동기화 실패: \(error)")
        // }
        
        print("🔄 서버 승률 동기화 (구현 예정)")
    }
    
    // MARK: - Public Methods
    func createBallLog() async {
        print("=== 볼로그 생성 시작 ===")
        
        guard validateInput() else {
            print("❌ 입력 데이터 검증 실패")
            return
        }
        
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("🔄 API 요청 데이터 생성 중...")
            let request = try await buildCreateRequest()
            
            print("🌐 API 호출 시작...")
            let response = try await createService.createBallLog(request)
            
            print("📨 API 응답 받음:")
            print("  - 응답 코드: \(response.code)")
            print("  - 응답 메시지: \(response.message)")
            
            if response.code == "OK" {
                print("✅ 볼로그 생성 성공!")
                isSuccessful = true
                
                // 승률 업데이트
                updateWinRateAfterLogCreation()
            } else {
                print("❌ 서버 오류: \(response.message)")
                errorMessage = response.message
            }
            
        } catch ValidationError.invalidData {
            print("❌ 데이터 변환 오류 발생")
            errorMessage = "입력된 데이터를 처리할 수 없습니다. 모든 필드를 확인해주세요."
        } catch {
            print("❌ API 호출 오류: \(error)")
            print("  - 오류 타입: \(type(of: error))")
            print("  - 오류 상세: \(error.localizedDescription)")
            errorMessage = "볼로그 생성에 실패했습니다: \(error.localizedDescription)"
        }
        
        isLoading = false
        print("=== 볼로그 생성 완료 ===")
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func resetForm() {
        title = ""
        gameDate = nil
        stadium = ""
        myTeam = ""
        myTeamScore = "0"
        opposingTeam = ""
        opposingTeamScore = "0"
        photoList = []
        logContent = ""
        isSuccessful = false
    }
    
    // MARK: - Private Methods
    private func validateInput() -> Bool {
        print("=== 입력 데이터 검증 시작 ===")
        print("제목: '\(title)' (길이: \(title.count))")
        print("내용: '\(logContent)' (길이: \(logContent.count))")
        print("응원팀: '\(myTeam)'")
        print("상대팀: '\(opposingTeam)'")
        print("응원팀 점수: '\(myTeamScore)'")
        print("상대팀 점수: '\(opposingTeamScore)'")
        print("경기장: '\(stadium)'")
        print("사진 개수: \(photoList.count)")
        print("경기 날짜: \(gameDate?.description ?? "nil")")
        
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            print("❌ 검증 실패: 제목이 비어있음")
            errorMessage = "제목을 입력해주세요."
            return false
        }
        
        if title.count > 28 {
            print("❌ 검증 실패: 제목이 28자 초과 (\(title.count)자)")
            errorMessage = "제목은 28자 이하로 입력해주세요."
            return false
        }
        
        if logContent.trimmingCharacters(in: .whitespaces).isEmpty {
            print("❌ 검증 실패: 내용이 비어있음")
            errorMessage = "내용을 입력해주세요."
            return false
        }
        
        if logContent.count > 150 {
            print("❌ 검증 실패: 내용이 150자 초과 (\(logContent.count)자)")
            errorMessage = "내용은 150자 이하로 입력해주세요."
            return false
        }
        
        if myTeam.isEmpty {
            print("❌ 검증 실패: 응원팀이 선택되지 않음")
            errorMessage = "응원팀을 선택해주세요."
            return false
        }
        
        if opposingTeam.isEmpty {
            print("❌ 검증 실패: 상대팀이 선택되지 않음")
            errorMessage = "상대팀을 선택해주세요."
            return false
        }
        
        if myTeam == opposingTeam {
            print("❌ 검증 실패: 응원팀과 상대팀이 동일함")
            errorMessage = "응원팀과 상대팀은 달라야 합니다."
            return false
        }
        
        if myTeamScore.isEmpty {
            print("❌ 검증 실패: 응원팀 점수가 비어있음")
            errorMessage = "응원팀 점수를 입력해주세요."
            return false
        }
        
        if opposingTeamScore.isEmpty {
            print("❌ 검증 실패: 상대팀 점수가 비어있음")
            errorMessage = "상대팀 점수를 입력해주세요."
            return false
        }
        
        // 점수가 숫자인지 확인
        guard let _ = Int(myTeamScore) else {
            print("❌ 검증 실패: 응원팀 점수가 숫자가 아님 ('\(myTeamScore)')")
            errorMessage = "응원팀 점수는 숫자만 입력 가능합니다."
            return false
        }
        
        guard let _ = Int(opposingTeamScore) else {
            print("❌ 검증 실패: 상대팀 점수가 숫자가 아님 ('\(opposingTeamScore)')")
            errorMessage = "상대팀 점수는 숫자만 입력 가능합니다."
            return false
        }
        
        if stadium.isEmpty {
            print("❌ 검증 실패: 경기장이 선택되지 않음")
            errorMessage = "경기장을 선택해주세요."
            return false
        }
        
        if photoList.count > 4 {
            print("❌ 검증 실패: 사진이 4장 초과 (\(photoList.count)장)")
            errorMessage = "사진은 최대 4장까지 업로드할 수 있습니다."
            return false
        }
        
        print("✅ 모든 검증 통과")
        return true
    }
    
    private func buildCreateRequest() async throws -> BallLogCreateRequest {
        print("=== API 요청 데이터 생성 시작 ===")
        
        guard let cheeringTeamId = getTeamId(for: myTeam) else {
            print("❌ 응원팀 ID 변환 실패: '\(myTeam)'")
            print("사용 가능한 팀 목록:")
            for team in teamInfoList {
                print("  - ID: \(team.id), 이름: '\(team.name)'")
            }
            throw ValidationError.invalidData
        }
        print("✅ 응원팀 ID: \(cheeringTeamId)")
        
        guard let opposingTeamId = getTeamId(for: opposingTeam) else {
            print("❌ 상대팀 ID 변환 실패: '\(opposingTeam)'")
            print("사용 가능한 팀 목록:")
            for team in teamInfoList {
                print("  - ID: \(team.id), 이름: '\(team.name)'")
            }
            throw ValidationError.invalidData
        }
        print("✅ 상대팀 ID: \(opposingTeamId)")
        
        guard let stadiumId = getStadiumId(for: stadium) else {
            print("❌ 경기장 ID 변환 실패: '\(stadium)'")
            print("사용 가능한 경기장 목록:")
            for stadium in stadiumInfoList {
                print("  - ID: \(stadium.id), 이름: '\(stadium.name)'")
            }
            throw ValidationError.invalidData
        }
        print("✅ 경기장 ID: \(stadiumId)")
        
        guard let cheeringScore = Int(myTeamScore) else {
            print("❌ 응원팀 점수 변환 실패: '\(myTeamScore)'")
            throw ValidationError.invalidData
        }
        print("✅ 응원팀 점수: \(cheeringScore)")
        
        guard let opposingScore = Int(opposingTeamScore) else {
            print("❌ 상대팀 점수 변환 실패: '\(opposingTeamScore)'")
            throw ValidationError.invalidData
        }
        print("✅ 상대팀 점수: \(opposingScore)")
        
        // 사진 업로드 및 URL 생성
        let photos = try await processPhotos()
        print("✅ 사진 처리 완료: \(photos.count)장")
        
        // 날짜 포맷팅
        let matchDateString = gameDate?.toISO8601String()
        print("✅ 경기 날짜: \(matchDateString ?? "nil")")
        
        let request = BallLogCreateRequest(
            cheeringTeamId: cheeringTeamId,
            opposingTeamId: opposingTeamId,
            scoreCheering: cheeringScore,
            scoreOpposing: opposingScore,
            title: title.trimmingCharacters(in: .whitespaces),
            content: logContent.trimmingCharacters(in: .whitespaces),
            stadiumId: stadiumId,
            matchDate: matchDateString,
            photos: photos
        )
        
        print("=== 최종 API 요청 데이터 ===")
        print("cheeringTeamId: \(request.cheeringTeamId)")
        print("opposingTeamId: \(request.opposingTeamId)")
        print("scoreCheering: \(request.scoreCheering)")
        print("scoreOpposing: \(request.scoreOpposing)")
        print("title: '\(request.title)'")
        print("content: '\(request.content)'")
        print("stadiumId: \(request.stadiumId)")
        print("matchDate: \(request.matchDate ?? "nil")")
        print("photos: \(request.photos.count)장")
        
        return request
    }
    
    private func getTeamId(for teamName: String) -> Int? {
        return teamInfoList.first { $0.name == teamName }?.id
    }
    
    private func getStadiumId(for stadiumName: String) -> Int? {
        return stadiumInfoList.first { $0.name == stadiumName }?.id
    }
    
    private func processPhotos() async throws -> [PhotoRequest] {
        print("=== 사진 업로드 시작 ===")
        print("업로드할 사진 개수: \(photoList.count)")
        
        var photoRequests: [PhotoRequest] = []
        
        for (index, item) in photoList.enumerated() {
            print("📷 사진 \(index + 1) 처리 중...")
            
            do {
                // 1. PhotosPickerItem에서 Data 추출
                guard let imageData = try await item.loadTransferable(type: Data.self) else {
                    print("❌ 사진 \(index + 1) 데이터 로드 실패")
                    throw PhotoProcessingError.dataLoadFailed
                }
                
                print("✅ 사진 \(index + 1) 데이터 로드 완료 (크기: \(imageData.count) bytes)")
                
                // 2. 파일명 생성 (타임스탬프 + 순서)
                let timestamp = Int(Date().timeIntervalSince1970)
                let fileName = "balllog_\(timestamp)_\(index + 1).jpg"
                print("📝 파일명: \(fileName)")
                
                // 3. Presigned URL 요청
                print("🔗 Presigned URL 요청 중...")
                let presignedResponse = try await fileUploadService.getPresignedUrl(fileName: fileName)
                
                if presignedResponse.code != "OK" {
                    print("❌ Presigned URL 요청 실패: \(presignedResponse.message)")
                    throw PhotoProcessingError.presignedUrlFailed
                }
                
                print("✅ Presigned URL 획득: \(presignedResponse.data.url.prefix(50))...")
                
                // 4. S3에 파일 업로드
                print("☁️ S3 업로드 시작...")
                try await fileUploadService.uploadFile(to: presignedResponse.data.url, data: imageData)
                print("✅ S3 업로드 완료")
                
                // 5. 업로드된 파일의 최종 URL 생성 (Presigned URL에서 쿼리 파라미터 제거)
                let finalUrl = extractFinalUrl(from: presignedResponse.data.url)
                print("🌐 최종 URL: \(finalUrl)")
                
                // 6. PhotoRequest 객체 생성
                let photoRequest = PhotoRequest(
                    imgUrl: finalUrl,
                    sequence: index + 1
                )
                photoRequests.append(photoRequest)
                
                print("✅ 사진 \(index + 1) 처리 완료")
                
            } catch {
                print("❌ 사진 \(index + 1) 처리 실패: \(error)")
                throw error
            }
        }
        
        print("✅ 모든 사진 업로드 완료: \(photoRequests.count)장")
        return photoRequests
    }
    
    // Presigned URL에서 최종 파일 URL 추출
    private func extractFinalUrl(from presignedUrl: String) -> String {
        // Presigned URL: https://s3.amazonaws.com/bucket/path/file.jpg?X-Amz-Algorithm=...
        // 최종 URL: https://s3.amazonaws.com/bucket/path/file.jpg
        if var urlComponents = URLComponents(string: presignedUrl) {
            urlComponents.queryItems = nil // 쿼리 파라미터 제거
            return urlComponents.url?.absoluteString ?? presignedUrl
        }
        return presignedUrl
    }
}
