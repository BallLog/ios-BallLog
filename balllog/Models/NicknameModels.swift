//
//  NicknameModels.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation

struct NicknameValidation {
    let nickname: String
    let isValid: Bool
    let message: String
    
    static func validate(_ nickname: String) -> NicknameValidation {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        
        // 빈 문자열 체크
        guard !trimmed.isEmpty else {
            return NicknameValidation(nickname: nickname, isValid: false, message: "닉네임을 입력해주세요.")
        }
        
        // 길이 체크 (10자 이내)
        guard trimmed.count <= 10 else {
            return NicknameValidation(nickname: nickname, isValid: false, message: "닉네임은 10자 이내로 입력해주세요.")
        }
        
        // 영어, 한글, 숫자, 공백만 허용
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789가-힣 ")
        guard trimmed.unicodeScalars.allSatisfy({ allowedCharacterSet.contains($0) }) else {
            return NicknameValidation(nickname: nickname, isValid: false, message: "영어, 한글, 숫자만 사용할 수 있습니다.")
        }
        
        return NicknameValidation(nickname: nickname, isValid: true, message: "사용 가능한 닉네임입니다.")
    }
}

struct NicknameCheckRequest: Codable {
    let nickname: String
}

struct NicknameCheckResponse: Codable {
    let code: String
    let message: String
    let data: NicknameCheckData
}

struct NicknameCheckData: Codable {
    let isAvailable: Bool
    let message: String
}

struct NicknameUpdateRequest: Codable {
    let nickname: String
}

struct NicknameUpdateResponse: Codable {
    let code: String
    let message: String
    let data: NicknameUpdateData
}

struct NicknameUpdateData: Codable {
    let nickname: String
}
