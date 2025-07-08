//
//  TermsService.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation

protocol TermsServiceProtocol {
    func saveTermsAgreement(_ agreement: TermsAgreement) async throws
    func getTermsContent() async throws -> String
    func getPrivacyPolicyContent() async throws -> String
}

class TermsService: TermsServiceProtocol {
    private let baseURL: String
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        self.baseURL = apiUrl
    }
    
    func saveTermsAgreement(_ agreement: TermsAgreement) async throws {
        print("📋 약관 동의 정보 저장 시작")
        
        // 로컬에 저장
        UserDefaults.standard.set(agreement.isTermsAgreed, forKey: "terms_agreed")
        UserDefaults.standard.set(agreement.isPrivacyAgreed, forKey: "privacy_agreed")
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "terms_agreed_date")
        
        print("✅ 약관 동의 정보 로컬 저장 완료")
        
        // TODO: 서버에도 저장 필요한 경우 구현
        // let request = TermsAgreementRequest(...)
        // try await api.saveTermsAgreement(request)
    }
    
    func getTermsContent() async throws -> String {
        // TODO: 서버에서 최신 이용약관 가져오기
        return """
        제1조(목적) 이 약관은 볼로그팀(전자상거래 사업자)가 운영하는 볼로그(이하 "몰"이라 한다)에서 제공하는 인터넷 관련 서비스(이하 "서비스"라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리․의무 및 책임사항을 규정함을 목적으로 합니다.
        
        제2조(정의) 이 약관에서 사용하는 용어의 정의는 다음과 같습니다...
        """
    }
    
    func getPrivacyPolicyContent() async throws -> String {
        // TODO: 서버에서 최신 개인정보처리방침 가져오기
        return """
        개인정보처리방침
        
        제1조(개인정보의 처리목적) 볼로그는 다음의 목적을 위하여 개인정보를 처리합니다...
        """
    }
}
