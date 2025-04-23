//
//  APIUtils.swift
//  balllog
//
//  Created by Nada on 4/20/25.
//

import Foundation

class APIUtils {
    static func getApiUrl() -> String? {
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            return nil // API URL이 없으면 nil 반환
        }
        return apiUrl
    }
}
