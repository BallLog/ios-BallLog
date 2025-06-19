//
//  LogAddView.swift
//  balllog
//
//  Created by 전은혜 on 1/11/25.
//

import SwiftUI
import PhotosUI

struct LogAddView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = LogAddViewModel()
    @State private var selection: NavigationDestination? = nil
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                
                ScrollView {
                    LogCardView(viewModel: viewModel, isFocused: _isFocused)
                }
                .padding(.top, 70.0)
                .navigationBarBackButtonHidden(true)

                VStack {
                    LogHeaderView(
                        hasAnyInput: viewModel.hasAnyInput,
                        showExitConfirmation: $viewModel.showExitConfirmation,
                        dismiss: dismiss
                    )

                    Spacer()

                    LogSaveButtonView(
                        isFormValid: viewModel.isFormValid,
                        onSave: {
                            viewModel.saveLog()
                            selection = .detail
                        }
                    )
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
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .simultaneousGesture(TapGesture().onEnded { isFocused = false })
            .navigationDestination(for: NavigationDestination.self) { value in
                if value == .detail {
                    BallLogDetailView()
                }
            }
            .gesture(
                viewModel.showExitConfirmation ?
                DragGesture().onChanged { _ in } : nil
            )
        }
    }
}

#Preview {
    LogAddView()
}
