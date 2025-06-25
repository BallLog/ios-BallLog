//
//  HomeView.swift
//  balllog
//
//  Created by 전은혜 on 10/28/24.
//

import SwiftUI

// 카드 데이터 모델
struct CardItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
    let isPrimary: Bool
}


struct HomeView: View {
    @State private var selectedCard: CardItem?
    @State private var showLogAdd = false

    var body: some View {
        NavigationStack {
            ZStack {
                BallLogListView(
                    selectedCard: $selectedCard,
                    showLogAdd: $showLogAdd)
                HeaderView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(item: $selectedCard) { card in
            BallLogDetailView()
        }
    }
}

#Preview {
    HomeView()
}
