//
//  WithdrawalViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//
import Foundation
import Combine

@MainActor
class WithdrawalViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var withdrawalReason: String = ""
    @Published var hasAgreed: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isWithdrawn = false
    
    // MARK: - Computed Properties
    var canWithdraw: Bool {
        !withdrawalReason.trimmingCharacters(in: .whitespaces).isEmpty && hasAgreed
    }
    
    // MARK: - Private Properties
    private let myPageService: MyPageServiceProtocol
    private let authViewModel: AuthViewModel
    
    // MARK: - Initialization
    init(myPageService: MyPageServiceProtocol = MyPageService(), authViewModel: AuthViewModel) {
        self.myPageService = myPageService
        self.authViewModel = authViewModel
    }
    
    // MARK: - Public Methods
    func withdrawUser() async {
        guard canWithdraw else {
            errorMessage = "탈퇴 조건을 모두 확인해주세요."
            return
        }
        
        print("=== 회원탈퇴 시작 ===")
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await myPageService.withdrawUser(reason: withdrawalReason)
            
            if response.code == "OK" {
                print("✅ 회원탈퇴 성공")
                
                // AuthViewModel을 통한 로그아웃 처리
                await authViewModel.logout()
                
                isWithdrawn = true
            } else {
                print("❌ 회원탈퇴 실패: \(response.message)")
                errorMessage = response.message
            }
            
        } catch {
            print("❌ 회원탈퇴 오류: \(error)")
            
            if let myPageError = error as? MyPageError {
                errorMessage = myPageError.localizedDescription
            } else {
                errorMessage = "회원탈퇴 중 오류가 발생했습니다."
            }
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
