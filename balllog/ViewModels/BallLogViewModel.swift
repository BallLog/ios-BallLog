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
    
    // MARK: - Initialization
    init(ballLogService: BallLogServiceProtocol = BallLogService()) {
        self.ballLogService = ballLogService
    }
    
    // MARK: - Public Methods
    func fetchBallLogs(reset: Bool = false, winning: Bool = false) async {
        if reset {
            currentPage = 0
            ballLogs.removeAll()
            hasMorePages = true
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await ballLogService.fetchBallLogs(
                page: currentPage,
                size: pageSize,
                onlyWin: winning ? true : nil
            )
            
            if reset {
                ballLogs = response.data.content
            } else {
                ballLogs.append(contentsOf: response.data.content)
            }
            
            hasMorePages = !response.data.last
            currentPage += 1
            
        } catch {
            errorMessage = "데이터를 불러오는데 실패했습니다: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func loadMoreBallLogs() async {
        guard hasMorePages && !isLoading else { return }
        await fetchBallLogs()
    }
    
    func refreshBallLogs() async {
        await fetchBallLogs(reset: true)
    }
    
    func clearError() {
        errorMessage = nil
    }
}
