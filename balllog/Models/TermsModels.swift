//
//  TermsModels.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation

struct TermsAgreement {
    let isAllAgreed: Bool
    let isTermsAgreed: Bool
    let isPrivacyAgreed: Bool
    
    var canProceed: Bool {
        isTermsAgreed && isPrivacyAgreed
    }
}
