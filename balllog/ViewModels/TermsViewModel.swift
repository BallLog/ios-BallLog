//
//  TermsViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation
import Combine

class TermsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isAllAgreed: Bool = false
    @Published var isTermsAgreed: Bool = false
    @Published var isPrivacyAgreed: Bool = false
    @Published var shouldNavigate: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Computed Properties
    var canProceed: Bool {
        isTermsAgreed && isPrivacyAgreed
    }
    
    // MARK: - Private Properties
    private let termsService: TermsServiceProtocol
    private var isAllAgreedDirectly: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(termsService: TermsServiceProtocol = TermsService()) {
        self.termsService = termsService
        setupBindings()
        loadSavedAgreements()
    }
    
    // MARK: - Public Methods
    func proceedToNext() async {
        guard canProceed else {
            errorMessage = "모든 필수 약관에 동의해주세요."
            return
        }
        
        print("=== 약관 동의 완료 후 다음 단계 진행 ===")
        isLoading = true
        errorMessage = nil
        
        do {
            let agreement = TermsAgreement(
                isAllAgreed: isAllAgreed,
                isTermsAgreed: isTermsAgreed,
                isPrivacyAgreed: isPrivacyAgreed
            )
            
            try await termsService.saveTermsAgreement(agreement)
            
            shouldNavigate = true
            print("✅ 약관 동의 처리 완료")
            
        } catch {
            print("❌ 약관 동의 저장 실패: \(error)")
            errorMessage = "약관 동의 처리 중 오류가 발생했습니다."
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    // 체크박스 로직 설정
    private func setupBindings() {
        // 전체 동의 상태 변화 감지
        $isAllAgreed
            .sink { [weak self] newValue in
                guard let self = self else { return }
                
                if newValue && !isAllAgreedDirectly {
                    print("📋 전체 동의 ON - 모든 하위 약관 동의")
                    isAllAgreedDirectly = true
                    self.isPrivacyAgreed = true
                    self.isTermsAgreed = true
                } else if !newValue && isAllAgreedDirectly {
                    print("📋 전체 동의 OFF - 모든 하위 약관 비동의")
                    isAllAgreedDirectly = false
                    self.isPrivacyAgreed = false
                    self.isTermsAgreed = false
                }
            }
            .store(in: &cancellables)
        
        // 개별 약관 상태 변화 감지
        Publishers.CombineLatest($isTermsAgreed, $isPrivacyAgreed)
            .sink { [weak self] terms, privacy in
                guard let self = self else { return }
                
                if isAllAgreedDirectly {
                    // 전체 동의 상태에서 개별 약관이 해제되면 전체 동의도 해제
                    if self.isAllAgreed && (!terms || !privacy) {
                        print("📋 개별 약관 해제로 인한 전체 동의 해제")
                        isAllAgreedDirectly = false
                        self.isAllAgreed = false
                    }
                } else {
                    // 개별 약관이 모두 동의되면 전체 동의 활성화
                    if terms && privacy && !self.isAllAgreed {
                        print("📋 모든 개별 약관 동의로 인한 전체 동의 활성화")
                        self.isAllAgreed = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // 저장된 약관 동의 정보 로드
    private func loadSavedAgreements() {
        let savedTerms = UserDefaults.standard.bool(forKey: "terms_agreed")
        let savedPrivacy = UserDefaults.standard.bool(forKey: "privacy_agreed")
        
        if savedTerms && savedPrivacy {
            print("📋 저장된 약관 동의 정보 로드")
            isTermsAgreed = savedTerms
            isPrivacyAgreed = savedPrivacy
            isAllAgreed = true
        }
    }
}
