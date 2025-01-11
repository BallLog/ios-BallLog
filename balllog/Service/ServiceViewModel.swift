//
//  ServiceViewModel.swift
//  balllog
//
//  Created by 전은혜 on 1/11/25.
//

import Foundation

class ServiceViewModel: ObservableObject {
    enum Tab: Hashable {
            case home, mypage, add
        }
    
    @Published var selectedTab: Tab = .home {
        didSet {
            if selectedTab == .add {
                shouldPresentLogView = true
                selectedTab = .home // 초기화
            }
        }
    }
    @Published var shouldPresentLogView: Bool = false
}
