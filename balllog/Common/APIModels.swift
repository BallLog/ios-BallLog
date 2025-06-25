//
//  APIModels.swift
//  balllog
//
//  Created by 전은혜 on 6/24/25.
//

import Foundation

// 사용자 프로필 관련
struct UserProfileResponse: Codable {
    let data: UserProfileData
    let code: String
    let message: String
}

struct UserProfileData: Codable {
    let id: String
    let email: String?
    let name: String?
    let profileImage: String?
}

// 일기 관련 (예시)
struct DiaryCreateRequest: Codable {
    let title: String
    let content: String
}

struct DiaryResponse: Codable {
    let data: DiaryData?
    let code: String
    let message: String
}

struct DiaryData: Codable {
    let id: String
    let title: String
    let content: String
    let createdAt: String
}
