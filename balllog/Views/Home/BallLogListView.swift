//
//  BallLogListView.swift
//  balllog
//
//  Created by 전은혜 on 6/25/25.
//

import SwiftUI

struct BallLogListView: View {
    @Binding var selectedCard: CardItem?
    @Binding var showLogAdd: Bool
    @ObservedObject var viewModel: BallLogViewModel
    @Binding var currentFilter: FilterOption
    
    var body: some View {
        VStack(alignment: .center) {
            if shouldShowContent {
                ballLogScrollView
            } else if shouldShowEmptyState {
                emptyStateView
            }
        }
        .padding(.top, 60)
        .alert("오류", isPresented: errorBinding) {
            Button("확인") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Computed Properties
    private var shouldShowContent: Bool {
        !viewModel.ballLogs.isEmpty || viewModel.isLoading
    }
    
    private var shouldShowEmptyState: Bool {
        !viewModel.isLoading
    }
    
    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in }
        )
    }
    
    // MARK: - View Components
    private var ballLogScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 20.0) {
                ForEach(viewModel.ballLogs) { ballLog in
                    ballLogCardView(for: ballLog)
                        .onTapGesture {
                            handleCardTap(for: ballLog)
                        }
                        .onAppear {
                            handleCardAppear(for: ballLog, filter: currentFilter)
                        }
                }
                
                if viewModel.isLoading {
                    loadingView
                }
            }
            .padding(.horizontal, 20)
        }
        .refreshable {
            await refreshData(filter: currentFilter)
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            AddBallLogView(showLogAdd: $showLogAdd)
            Spacer()
            Spacer()
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .padding()
    }
    
    // MARK: - Helper Methods
    @ViewBuilder
    private func ballLogCardView(for ballLog: BallLogSimpleResponse) -> some View {
        Group {
            if isFirstCard(ballLog) {
                PrimaryCardView(ballLog: ballLog)
            } else {
                SubCardView(ballLog: ballLog)
            }
        }
    }
    
    private func isFirstCard(_ ballLog: BallLogSimpleResponse) -> Bool {
        ballLog.id == viewModel.ballLogs.first?.id
    }
    
    private func handleCardTap(for ballLog: BallLogSimpleResponse) {
        print("TAP \(ballLog.id)!")
        selectedCard = CardItem(
            ballLogId: ballLog.id,
            title: ballLog.title,
            content: ballLog.content,
            isPrimary: isFirstCard(ballLog)
        )
    }
    
    private func handleCardAppear(for ballLog: BallLogSimpleResponse, filter: FilterOption) {
        if ballLog.id == viewModel.ballLogs.last?.id {
            Task {
                await viewModel.loadMoreBallLogs(filter: filter)
            }
        }
    }
    
    private func refreshData(filter: FilterOption) async {
        print("🔄 BallLogListView refreshData 시작 - filter: \(filter)")
        await viewModel.refreshBallLogs(filter: filter)
        print("🔄 BallLogListView refreshData 완료")
    }
}
