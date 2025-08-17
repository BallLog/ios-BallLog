//
//  BallLogDetailView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct BallLogDetailView: View {
    let ballLogId: String
    @StateObject private var viewModel: BallLogDetailViewModel
    @Environment(\.dismiss) var dismiss
    let serviceVM: ServiceViewModel?
    let onDelete: (() -> Void)?
    @State private var showShareView = false
    
    init(ballLogId: String = "0", serviceVM: ServiceViewModel? = nil, onDelete: (() -> Void)? = nil) {
        self.ballLogId = ballLogId
        self.serviceVM = serviceVM
        self.onDelete = onDelete
        self._viewModel = StateObject(wrappedValue: BallLogDetailViewModel(ballLogId: ballLogId))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    loadingView
                } else if let displayData = viewModel.displayData {
                    mainContentView(displayData: displayData)
                } else {
                    emptyStateView
                }
                
                // 고정 헤더
                VStack {
                    DetailHeaderView(
                        title: "볼로그",
                        customDismissAction: {
                            serviceVM?.showTabBarAgain()
                            dismiss()
                        }
                    )
                    Spacer()
                }
                
                // 고정 컨트롤 버튼
                VStack {
                    Spacer()
                    BallLogDetailControlView(viewModel: viewModel, showShareView: $showShareView)
                }
                
                // 삭제 확인 모달
                if viewModel.showDeleteConfirmation {
                    DeleteConfirmationModal(viewModel: viewModel)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await viewModel.loadBallLogDetail()
            }
        }
        .onChange(of: viewModel.isDeleted) { _, isDeleted in
            if isDeleted {
                onDelete?()
                dismiss()
            }
        }
        .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("확인") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .fullScreenCover(isPresented: $showShareView) {
            ShareLogView(viewModel: viewModel)
        }
    }
    
    // MARK: - View Components
    private var loadingView: some View {
        VStack {
            ProgressView("로딩 중...")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack {
            Text("볼로그를 불러올 수 없습니다")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func mainContentView(displayData: BallLogDisplayData) -> some View {
        ScrollView {
            VStack {
                Spacer().frame(minHeight: 10)
                BallLogCardView(displayData: displayData)
                Spacer().frame(minHeight: 22)
            }
            .padding(.top, 60)
            .padding(.bottom, 73)
        }
    }
}
