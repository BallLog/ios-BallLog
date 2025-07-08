//
//  MyPageViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation
import Combine

@MainActor
class MyPageViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var myPageProfile: MyPageProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showLogoutPopup = false
    @Published var isLoggedOut = false
    
    // MARK: - Private Properties
    private let myPageService: MyPageServiceProtocol
    private let authViewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(myPageService: MyPageServiceProtocol = MyPageService(), authViewModel: AuthViewModel) {
        self.myPageService = myPageService
        self.authViewModel = authViewModel
    }
    
    // MARK: - Public Methods
    func loadMyPageProfile() async {
        print("=== 마이페이지 프로필 로드 시작 ===")
        isLoading = true
        errorMessage = nil
        
        do {
            let profile = try await myPageService.getMyPageProfile()
            myPageProfile = profile
            print("✅ 마이페이지 프로필 로드 성공")
        } catch {
            print("❌ 마이페이지 프로필 로드 실패: \(error)")
            errorMessage = "프로필을 불러올 수 없습니다."
        }
        
        isLoading = false
    }
    
    func showLogoutConfirmation() {
        showLogoutPopup = true
    }
    
    func hideLogoutPopup() {
        showLogoutPopup = false
    }
    
    func logout() async {
        print("=== 로그아웃 시작 ===")
        isLoading = true
        errorMessage = nil
        
        do {
            // 서버 로그아웃 시도
            try await myPageService.logout()
            
            // AuthViewModel을 통한 로그아웃 처리
            await authViewModel.logout()
            
            // 상태 업데이트
            isLoggedOut = true
            showLogoutPopup = false
            
            print("✅ 로그아웃 완료")
            
        } catch {
            print("❌ 로그아웃 오류: \(error)")
            // 서버 로그아웃 실패해도 로컬 로그아웃은 진행
            await authViewModel.logout()
            isLoggedOut = true
            showLogoutPopup = false
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
