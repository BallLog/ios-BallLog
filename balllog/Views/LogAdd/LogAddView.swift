//
//  LogAddView.swift
//  balllog
//
//  Created by 전은혜 on 1/11/25.
//

import SwiftUI
import PhotosUI

enum LogAddNavigationDestination: Hashable {
    case detail
}

struct LogAddView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = BallLogCreateViewModel()
    @State private var selection: LogAddNavigationDestination? = nil
    @FocusState private var isFocused: Bool
    @StateObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Color.white
                        .ignoresSafeArea()
                        .onTapGesture {
                            // 빈 공간만 터치했을 때만 키보드 숨기기
                            isFocused = false
                        }
                    
                    // 메인 콘텐츠
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 0) {
                                // 헤더 공간
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 70)
                                    .id("header")
                                    .allowsHitTesting(false) // 터치 무시
                                
                                // 로그 카드
                                LogCardView(viewModel: viewModel, isFocused: _isFocused)
                                    .id("logCard")
                                    .allowsHitTesting(true)
                                
                                // 키보드 높이만큼 여백 추가
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: keyboardResponder.currentHeight + 20)
                                    .id("keyboardSpacer")
                                    .allowsHitTesting(false)
                                
                                // 저장 버튼 공간 (키보드가 없을 때만)
                                if !keyboardResponder.isKeyboardVisible {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: 100)
                                        .id("buttonSpacer")
                                        .allowsHitTesting(false)
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
                        .onChange(of: keyboardResponder.isKeyboardVisible) { _, isVisible in
                            if isVisible {
                                // 키보드가 나타나면 스크롤
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        proxy.scrollTo("keyboardSpacer", anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    
                    // 고정 헤더
                    VStack {
                        LogHeaderView(
                            hasAnyInput: viewModel.hasAnyInput,
                            showExitConfirmation: $viewModel.showExitConfirmation,
                            dismiss: dismiss
                        )
                        .allowsHitTesting(true)
                        Spacer()
                    }
                    
                    // 고정 저장 버튼 (키보드가 없을 때만)
                    if !keyboardResponder.isKeyboardVisible {
                        VStack {
                            Spacer()
                            LogSaveButtonView(
                                isFormValid: viewModel.isFormValid,
                                onSave: {
                                    isFocused = false // 키보드 숨기기
                                    Task {
                                        await viewModel.createBallLog()
                                        if viewModel.isSuccessful {
                                            selection = .detail
                                        }
                                    }
                                }
                            )
                            .allowsHitTesting(true)
                        }
                    }
                    
                    // 로딩 오버레이
                    if viewModel.isLoading {
                        ProgressView("저장 중...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.3))
                            .allowsHitTesting(false)
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
                        .allowsHitTesting(true)
                    }
                }
            }
            .navigationDestination(for: LogAddNavigationDestination.self) { value in
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
}
