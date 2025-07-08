//
//  HomeView.swift
//  balllog
//
//  Created by 전은혜 on 10/28/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedCard: CardItem?
    @State private var showLogAdd = false
    @StateObject private var viewModel = BallLogViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BallLogListView(
                    selectedCard: $selectedCard,
                    showLogAdd: $showLogAdd,
                    viewModel: viewModel
                )
                HeaderView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(item: $selectedCard) { card in
            BallLogDetailView()
        }
        .sheet(isPresented: $showLogAdd) {
            // 볼로그 추가 뷰
            Text("볼로그 추가 화면")
        }
        .onAppear {
            Task {
                await viewModel.fetchBallLogs(reset: true)
            }
        }
    }
}

#Preview {
    HomeView()
}
