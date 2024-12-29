//
//  LoginViewModel.swift
//  balllog
//
//  Created by 전은혜 on 10/28/24.
//

import Foundation

// TODO: 체크로직 이상함!!!!!!!
class TermsViewModel: ObservableObject {
    @Published var shouldNavigate: Bool = false // 화면 전환 상태

    @Published var isAllAgreed: Bool = false { // 전체 동의 상태
        didSet {
            // 전체 동의가 직접 변경될 때만 개별 항목을 변경
            if isAllAgreedDirectly {
                isTermsAgreed = isAllAgreed
                isPrivacyAgreed = isAllAgreed
            }
        }
    }
    
    @Published var isTermsAgreed: Bool = false { // 이용약관 동의
        didSet {
            updateAllAgreedStatus()
        }
    }
    
    @Published var isPrivacyAgreed: Bool = false { // 개인정보 활용방침 동의
        didSet {
            updateAllAgreedStatus()
        }
    }
    
    // 전체 동의가 직접 변경되었는지 추적하는 플래그
    private var isAllAgreedDirectly: Bool = true
    
    // MARK: - Private Method
    private func updateAllAgreedStatus() {
        // 개별 항목 모두 동의 시 전체 동의로 설정
        let newAllAgreed = isTermsAgreed && isPrivacyAgreed

        if isAllAgreed != newAllAgreed {
            isAllAgreedDirectly = false // 자동 변경임을 표시
            isAllAgreed = newAllAgreed
            isAllAgreedDirectly = true // 플래그 복원
        }
    }
    
    // MARK: - Public Method
    func toggleAllAgreed() {
        isAllAgreedDirectly = true
        isAllAgreed.toggle()
    }
}
