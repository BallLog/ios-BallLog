//
//  BallLogDetailViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//


import Foundation
import SwiftUI
import Combine

@MainActor
class BallLogDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var ballLogDetail: BallLogDetailResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showDeleteConfirmation = false
    @Published var isDeleted = false
    @Published var shareContent: String = ""
    
    // MARK: - Private Properties
    private let ballLogDetailService: BallLogDetailServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let ballLogId: String
    
    // MARK: - Computed Properties
    var displayData: BallLogDisplayData? {
        guard let detail = ballLogDetail else { return nil }
        return BallLogDisplayData(from: detail.data)
    }
    
    // MARK: - Initialization
    init(ballLogId: String, ballLogDetailService: BallLogDetailServiceProtocol = BallLogDetailService()) {
        self.ballLogId = ballLogId
        self.ballLogDetailService = ballLogDetailService
    }
    
    // MARK: - Public Methods
    func loadBallLogDetail() async {
        print("=== 볼로그 상세 조회 시작 ===")
        print("📋 볼로그 ID: \(ballLogId)")
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await ballLogDetailService.getBallLogDetail(id: ballLogId)
            
            if response.code == "OK" {
                ballLogDetail = response
                print("✅ 볼로그 상세 조회 성공")
            } else {
                print("❌ 볼로그 상세 조회 실패: \(response.message)")
                errorMessage = response.message
            }
            
        } catch {
            print("❌ 볼로그 상세 조회 오류: \(error)")
            errorMessage = "볼로그를 불러올 수 없습니다."
        }
        
        isLoading = false
    }
    
    func shareBallLog() {
        print("📤 볼로그 공유 시작")
        
        guard let displayData = displayData else {
            errorMessage = "공유할 내용이 없습니다."
            return
        }
        
        shareContent = generateShareContent(from: displayData)
        // TODO: 실제 공유 로직은 View에서 처리
    }
    
    func confirmDelete() {
        showDeleteConfirmation = true
    }
    
    func hideDeleteConfirmation() {
        showDeleteConfirmation = false
    }
    
    func deleteBallLog() async {
        print("🗑 볼로그 삭제 시작")
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await ballLogDetailService.deleteBallLog(id: ballLogId)
            
            if response.code == "OK" {
                print("✅ 볼로그 삭제 성공")
                isDeleted = true
                showDeleteConfirmation = false
            } else {
                print("❌ 볼로그 삭제 실패: \(response.message)")
                errorMessage = response.message
            }
            
        } catch {
            print("❌ 볼로그 삭제 오류: \(error)")
            errorMessage = "볼로그 삭제에 실패했습니다."
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    private func generateShareContent(from data: BallLogDisplayData) -> String {
        return """
        \(data.title)
        
        📅 \(data.formattedDate)
        🏟 \(data.stadiumName)
        ⚾️ \(data.cheeringTeamName) \(data.scoreCheering) : \(data.scoreOpposing) \(data.opposingTeamName)
        
        \(data.content)
        
        #볼로그 #직관일기 #\(data.cheeringTeamName)
        """
    }
}
