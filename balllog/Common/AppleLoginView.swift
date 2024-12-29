//
//  AppleLoginBtnView.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
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
              }
              
              if let error = viewModel.error {
                  Text("Error: \(error.localizedDescription)")
                      .foregroundColor(.red)
              }
          }
          .onChange(of: viewModel.loginSuccess) { success in
              if success {
                  // 로그인 성공 후 처리
                  // 예: 다음 화면으로 이동
              }
          }
      }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}
