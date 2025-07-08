//
//  FileUploadModels.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

struct PresignedUrlRequest: Codable {
    let fileName: String
}

struct PresignedUrlResponse: Codable {
    let code: String
    let message: String
    let data: PresignedUrlData
}

struct PresignedUrlData: Codable {
    let url: String
}
