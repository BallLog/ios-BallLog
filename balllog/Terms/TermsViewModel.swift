//
//  LoginViewModel.swift
//  balllog
//
//  Created by 전은혜 on 10/28/24.
//

import Foundation
import Combine

// MARK: - 체크박스 로직
// 모두 동의 true : 이용약관, 개인정보 모두 true
// 모두 동의 false : 이용약관, 개인정보 모두 false
// 이용약관과 개인정보가 모두 true : 모두 동의 true
// 모두 동의가 true인 상태에서, 하위 약관이 하나라도 false : 모두 동의도 false

// 참고 링크 https://masterpiece-programming.tistory.com/356

class TermsViewModel: ObservableObject {
    @Published var shouldNavigate: Bool = false // 화면 전환 상태
    
    @Published var isAllAgreed: Bool = false // 전체 동의
    @Published var isTermsAgreed: Bool = false // 이용약관 동의
    @Published var isPrivacyAgreed: Bool = false // 개인정보 활용방침 동의

    private var isAllAgreedDirectly: Bool = false // 전체 동의 직접 클릭 상태
    private var store: [AnyCancellable] = []

    init() {
        $isAllAgreed
            .sink { [weak self] newValue in
                guard let self = self else {return}
                if newValue && !isAllAgreedDirectly {
                    isAllAgreedDirectly = true
                    self.isPrivacyAgreed = true
                    self.isTermsAgreed = true
                } else if !newValue && isAllAgreedDirectly { // 전체 동의 off
                    isAllAgreedDirectly = false
                    self.isPrivacyAgreed = false
                    self.isTermsAgreed = false
                    
                }
            }
            .store(in: &store)
        
        Publishers.CombineLatest($isTermsAgreed, $isPrivacyAgreed)
            .sink { [weak self] terms, privacy in
                guard let self = self else {return}
            
                if isAllAgreedDirectly {
                    if self.isAllAgreed {
                        isAllAgreedDirectly = false
                        self.isAllAgreed = false
                    }
                } else {
                    if terms && privacy {
                        self.isAllAgreed = true
                    }
                }
            }
            .store(in: &store)
    }
}
