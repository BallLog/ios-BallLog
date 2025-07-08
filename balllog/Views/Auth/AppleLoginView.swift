//
//  AppleLoginView.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    @StateObject private var viewModel = AppleLoginViewModel()
    
    var body: some View {
        VStack {
            SignInWithAppleButton(
                onRequest: viewModel.handleAppleSignInRequest,
                onCompletion: viewModel.handleAppleSignInCompletion
            )
            .frame(height: 50)
            .signInWithAppleButtonStyle(.whiteOutline)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .alert("오류", isPresented: .constant(viewModel.error != nil)) {
            Button("확인") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
}
