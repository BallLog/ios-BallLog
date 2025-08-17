//
//  BallLogViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import Foundation
import SwiftUI

@MainActor
class BallLogViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var ballLogs: [BallLogSimpleResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMorePages = true
    
    // MARK: - Private Properties
    private let ballLogService: BallLogServiceProtocol
    private var currentPage = 0
    private let pageSize = 10
    private var currentTask: Task<Void, Never>?
    
    // MARK: - Initialization
    init(ballLogService: BallLogServiceProtocol = BallLogService()) {
        self.ballLogService = ballLogService
    }
    
    // MARK: - Public Methods
    func fetchBallLogs(reset: Bool = false, winning: Bool = false) async {
        print("📡 fetchBallLogs 시작 - reset: \(reset), winning: \(winning), page: \(currentPage)")
        
        // 이전 Task 취소
        currentTask?.cancel()
        
        if reset {
            print("🔄 데이터 리셋")
            currentPage = 0
            ballLogs.removeAll()
            hasMorePages = true
        }
        
        guard !isLoading else {
            print("⚠️ 이미 로딩 중이므로 요청 무시")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // 새로운 Task 생성
        currentTask = Task {
            do {
                print("🌐 API 호출 시작 - page: \(currentPage)")
                let response = try await ballLogService.fetchBallLogs(
                    page: currentPage,
                    size: pageSize,
                    onlyWin: winning == true ? true : nil
                )
                
                // Task가 취소되었는지 확인
                guard !Task.isCancelled else {
                    print("⚠️ Task가 취소됨")
                    return
                }
                
                print("✅ API 호출 성공 - 받은 데이터: \(response.data.content.count)개")
                
                await MainActor.run {
                    if reset {
                        ballLogs = response.data.content
                    } else {
                        ballLogs.append(contentsOf: response.data.content)
                    }
                    
                    hasMorePages = !response.data.last
                    currentPage += 1
                    
                    print("📊 현재 상태 - 총 데이터: \(ballLogs.count)개, hasMorePages: \(hasMorePages)")
                }
                
            } catch {
                await MainActor.run {
                    print("❌ API 호출 실패: \(error)")
                    
                    // CancellationError나 NSURLError cancelled는 사용자에게 표시하지 않음
                    if let urlError = error as? URLError, urlError.code == .cancelled {
                        print("🔄 요청이 취소됨 (사용자에게 표시하지 않음)")
                    } else if error is CancellationError {
                        print("🔄 Task가 취소됨 (사용자에게 표시하지 않음)")
                    } else {
                        errorMessage = "데이터를 불러오는데 실패했습니다: \(error.localizedDescription)"
                    }
                }
            }
            
            await MainActor.run {
                isLoading = false
                print("📡 fetchBallLogs 완료")
            }
        }
        
        await currentTask?.value
    }
    
    func loadMoreBallLogs(filter: FilterOption) async {
        guard hasMorePages && !isLoading else { return }
        
        switch filter {
        case .all:
            await fetchBallLogs(reset: false)
        case .winOnly:
            await fetchBallLogs(reset: false, winning: true)
        }
    }
    
    func refreshBallLogs(filter: FilterOption) async {
        print("🔄 refreshBallLogs 시작 - filter: \(filter)")
        switch filter {
        case .all:
            print("🔄 전체 볼로그 새로고침")
            await fetchBallLogs(reset: true)
        case .winOnly:
            print("🔄 승리 볼로그만 새로고침")
            await fetchBallLogs(reset: true, winning: true)
        }
        print("🔄 refreshBallLogs 완료")
    }
    
    func clearError() {
        errorMessage = nil
    }
}
