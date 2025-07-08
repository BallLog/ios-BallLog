//
//  Extensions.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import Foundation

extension Date {
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}

enum ValidationError: LocalizedError {
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "입력된 데이터가 올바르지 않습니다."
        }
    }
}

enum PhotoProcessingError: LocalizedError {
    case dataLoadFailed
    case presignedUrlFailed
    case uploadFailed
    
    var errorDescription: String? {
        switch self {
        case .dataLoadFailed:
            return "사진 데이터를 불러올 수 없습니다."
        case .presignedUrlFailed:
            return "사진 업로드 URL을 받아올 수 없습니다."
        case .uploadFailed:
            return "사진 업로드에 실패했습니다."
        }
    }
}
