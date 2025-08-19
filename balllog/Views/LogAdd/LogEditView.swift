//
//  LogEditView.swift
//  balllog
//
//  Created by 전은혜 on 8/19/25.
//

import SwiftUI
import PhotosUI

enum LogEditNavigationDestination: Hashable {
    case detail
}

struct LogEditView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: BallLogEditViewModel
    @State private var selection: LogEditNavigationDestination? = nil
    
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    @FocusState private var isFocused: Bool
    
    let onSave: (() -> Void)?
    
    init(displayData: BallLogDisplayData, onSave: (() -> Void)? = nil) {
        self._viewModel = StateObject(wrappedValue: BallLogEditViewModel(displayData: displayData))
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Color.white
                        .ignoresSafeArea()
                    
                    // 메인 콘텐츠
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 0) {
                                // 헤더 공간
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 70)
                                    .id("header")
                                
                                // 로그 카드
                                LogEditCardView(viewModel: viewModel, isFocused: _isFocused)
                                    .id("logCard")
                                
                                // 키보드 높이만큼 여백 추가
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: keyboardResponder.currentHeight)
                                    .id("keyboardSpacer")
                                
                                // 저장 버튼 공간 (키보드가 없을 때만)
                                if !keyboardResponder.isKeyboardVisible {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: 100)
                                        .id("buttonSpacer")
                                }
                            }
                        }
                        .onChange(of: isFocused) { _, isFocused in
                            if isFocused {
                                // 텍스트 영역이 포커스되면 해당 영역으로 스크롤
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        proxy.scrollTo("logCard", anchor: .center)
                                    }
                                }
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    
                    // 고정 헤더
                    VStack {
                        LogEditHeaderView(
                            hasDataChanged: viewModel.hasDataChanged,
                            showExitConfirmation: $viewModel.showExitConfirmation,
                            dismiss: dismiss
                        )
                        Spacer()
                    }
                    
                    // 고정 저장 버튼 (키보드가 없을 때만)
                    if !keyboardResponder.isKeyboardVisible {
                        VStack {
                            Spacer()
                            LogEditSaveButtonView(
                                isFormValid: viewModel.isFormValid,
                                onSave: {
                                    hideKeyboard()// 키보드 숨기기
                                    Task {
                                        await viewModel.updateBallLog()
                                        if viewModel.isSuccessful {
                                            onSave?()
                                            selection = .detail
                                            dismiss()
                                        }
                                    }
                                }
                            )
                        }
                    }
                    
                    // 로딩 오버레이
                    if viewModel.isLoading {
                        ProgressView("수정 중...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.3))
                    }
                    
                    // 커스텀 모달
                    if viewModel.showExitConfirmation {
                        ExitConfirmModal(
                            onStay: {
                                viewModel.showExitConfirmation = false
                            },
                            onExit: {
                                viewModel.showExitConfirmation = false
                                dismiss()
                            }
                        )
                        .animation(.easeInOut(duration: 0.3), value: viewModel.showExitConfirmation)
                    }
                }
            }
            .navigationDestination(for: LogEditNavigationDestination.self) { value in
                if value == .detail {
                    BallLogDetailView()
                }
            }
            .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("확인") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
    
    func hideKeyboard() {
        isFocused = false
    }
}