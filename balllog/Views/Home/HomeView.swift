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
    @State private var currentFilter: FilterOption = .all
    
    let serviceVM: ServiceViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                BallLogListView(
                    selectedCard: $selectedCard,
                    showLogAdd: $showLogAdd,
                    viewModel: viewModel,
                    currentFilter: $currentFilter
                )
                HeaderView { newFilter in
                    handleFilterChange(newFilter)
                }
            }
            .padding(.bottom, 76.0)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(item: $selectedCard) { card in
                BallLogDetailView(
                    ballLogId: String(card.ballLogId),
                    serviceVM: serviceVM,
                    onDelete: {
                        Task {
                            await loadData(filter: currentFilter)
                        }
                    }
                )
                .onAppear {
                    print("🔴 볼로그 상세 화면 - 탭바 숨김")
                    serviceVM.hideTabBar()
                }
            }
        }
        .fullScreenCover(isPresented: $showLogAdd) {
            LogAddView(onSave: {
                Task {
                    await loadData(filter: currentFilter)
                }
            })
        }
        .onAppear {
            Task {
                await loadData(filter: currentFilter)
            }
        }
    }
    
    private func handleFilterChange(_ newFilter: FilterOption) {
        currentFilter = newFilter
        Task {
            await loadData(filter: newFilter)
        }
    }
    
    private func loadData(filter: FilterOption) async {
        switch filter {
        case .all:
            await viewModel.fetchBallLogs(reset: true)
        case .winOnly:
            await viewModel.fetchBallLogs(reset: true, winning: true)
        }
    }
}

#Preview {
    HomeView(serviceVM: ServiceViewModel())
}
