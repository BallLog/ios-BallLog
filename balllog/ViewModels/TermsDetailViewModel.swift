//
//  TermsDetailViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation
import Combine

class TermsDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var termsContent: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let termsService: TermsServiceProtocol
    let contentType: ContentType
    
    enum ContentType {
        case terms
        case privacy
        
        var title: String {
            switch self {
            case .terms: return "서비스 이용약관"
            case .privacy: return "개인정보처리방침"
            }
        }
    }
    
    // MARK: - Initialization
    init(contentType: ContentType, termsService: TermsServiceProtocol = TermsService()) {
        self.contentType = contentType
        self.termsService = termsService
    }
    
    // MARK: - Public Methods
    func loadContent() async {
        print("=== 약관 내용 로드 시작: \(contentType.title) ===")
        isLoading = true
        errorMessage = nil
        
        do {
            switch contentType {
            case .terms:
                termsContent = try await termsService.getTermsContent()
            case .privacy:
                termsContent = try await termsService.getPrivacyPolicyContent()
            }
            
            print("✅ 약관 내용 로드 완료")
            
        } catch {
            print("❌ 약관 내용 로드 실패: \(error)")
            errorMessage = "약관 내용을 불러올 수 없습니다."
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
