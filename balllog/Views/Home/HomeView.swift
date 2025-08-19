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
            .padding(.bottom, 60.0)
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
            print("🏠 HomeView: onAppear 호출됨")
            print("🏠 HomeView: viewModel 인스턴스 주소 - \(Unmanaged.passUnretained(viewModel).toOpaque())")
            print("🏠 HomeView: 현재 ballLogs 개수 - \(viewModel.ballLogs.count)")
            Task {
                // 리프레시 플래그가 설정되어 있으면 리프레시
                if serviceVM.shouldRefreshHomeData {
                    print("🔄 HomeView: onAppear에서 리프레시 플래그 감지, 데이터 리프레시")
                    await loadData(filter: currentFilter)
                    serviceVM.shouldRefreshHomeData = false
                } else {
                    await loadData(filter: currentFilter)
                }
            }
        }
        .onChange(of: serviceVM.shouldRefreshHomeData) { _, shouldRefresh in
            print("🏠 HomeView: shouldRefreshHomeData 변경됨 - \(shouldRefresh)")
            if shouldRefresh {
                print("🔄 HomeView: 데이터 리프레시 시작")
                Task {
                    await loadData(filter: currentFilter)
                    print("✅ HomeView: 데이터 리프레시 완료, 플래그 리셋")
                    serviceVM.shouldRefreshHomeData = false // 플래그 리셋
                }
            }
        }
        .onChange(of: serviceVM.selectedTab) { _, newTab in
            print("🏠 HomeView: selectedTab 변경됨 - \(newTab)")
            if newTab == .home && serviceVM.shouldRefreshHomeData {
                print("🔄 HomeView: 홈탭으로 돌아왔고 리프레시 플래그 감지, 데이터 리프레시")
                Task {
                    await loadData(filter: currentFilter)
                    print("✅ HomeView: 데이터 리프레시 완료, 플래그 리셋")
                    serviceVM.shouldRefreshHomeData = false // 플래그 리셋
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BallLogSaved"))) { _ in
            print("🏠 HomeView: NotificationCenter에서 BallLogSaved 알림 수신")
            Task {
                print("🔄 HomeView: 데이터 리프레시 시작")
                await loadData(filter: currentFilter)
                print("✅ HomeView: 데이터 리프레시 완료")
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

//#Preview {
//    HomeView(serviceVM: ServiceViewModel())
//}

#Preview {
    ServiceViewPreview()
}
