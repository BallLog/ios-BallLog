//
//  AppleLoginModel.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
//

//
//import Foundation
//
//struct AppleLoginRequest: Codable {
//    let authorizationCode: String?
//    let email: String?
//    let firstName: String?
//    let lastName: String?
//}
//
//struct AppleLoginModel {
//    let userId: String
//    let email: String?
//    let fullName: PersonNameComponents?
//    let identityToken: Data?
//    let authorizationCode: Data?
//    
//    // Identity Token을 String으로 변환하는 computed property
//    var identityTokenString: String? {
//        guard let token = identityToken else { return nil }
//        return String(data: token, encoding: .utf8)
//    }
//    
//    // Authorization Code를 String으로 변환하는 computed property
//    var authorizationCodeString: String? {
//        guard let code = authorizationCode else { return nil }
//        return String(data: code, encoding: .utf8)
//    }
//}
