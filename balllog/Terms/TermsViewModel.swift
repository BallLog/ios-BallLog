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
        if isTermsAgreed && isPrivacyAgreed {
            isAllAgreed = true
        } else {
            isAllAgreed = false
        }
    }
    
    // MARK: - Public Method
    func toggleAllAgreed() {
        isAllAgreedDirectly = true
        isAllAgreed.toggle()
    }
}
