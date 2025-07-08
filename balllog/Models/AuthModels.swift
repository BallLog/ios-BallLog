//
//  AuthModels.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import Foundation
import AuthenticationServices

struct User: Codable {
    let id: String
    let email: String?
    let name: String?
    let loginType: LoginType
}

enum LoginType: String, Codable {
    case apple
    case kakao
    case none
}

struct LoginResponse: Codable {
    let data: LoginData?
    let code: String
    let message: String
}

struct LoginData: Codable {
    let status: String
    let tokenInfo: TokenInfo
}

struct TokenInfo: Codable {
    let grantType: String
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiresIn: Int64
    let refreshTokenExpiresIn: Int64
}

struct AppleLoginRequest: Codable {
    let authorizationCode: String?
    let email: String?
    let firstName: String?
    let lastName: String?
}

struct AppleLoginModel {
    let userId: String
    let email: String?
    let fullName: PersonNameComponents?
    let identityToken: Data?
    let authorizationCode: Data?
    
    var identityTokenString: String? {
        guard let token = identityToken else { return nil }
        return String(data: token, encoding: .utf8)
    }
    
    var authorizationCodeString: String? {
        guard let code = authorizationCode else { return nil }
        return String(data: code, encoding: .utf8)
    }
}

struct UserProfileResponse: Codable {
    let code: String
    let message: String
    let data: UserProfileData
}

struct UserProfileData: Codable {
    let id: String
    let email: String?
    let name: String?
}
