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
            print("🔄 ServiceViewModel: selectedTab 변경됨 - \(selectedTab)")
            if selectedTab == .add {
                shouldPresentLogView = true
                selectedTab = .home // 초기화
            }
        }
    }
    @Published var shouldPresentLogView: Bool = false
    @Published var showTabBar: Bool = true // 탭바 표시 상태 추가
    @Published var shouldRefreshHomeData: Bool = false // 홈뷰 데이터 리프레시 플래그

    func hideTabBar() {
        showTabBar = false
    }
    
    func showTabBarAgain() {
        showTabBar = true
    }
}
