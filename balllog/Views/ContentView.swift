//
//  ContentView.swift
//  balllog
//
//  Created by 전은혜 on 10/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainView = false
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var appleLoginViewModel = AppleLoginViewModel()

    var body: some View {
        Group {
            if showMainView {
                if authViewModel.isLoggedIn || appleLoginViewModel.loginSuccess {
                    ServiceView()
                        .environmentObject(authViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showMainView = true
                            }
                        }
                    }
            }
        }
        .environmentObject(authViewModel)
        .onAppear {
            authViewModel.checkAutoLogin()
        }
        .onChange(of: appleLoginViewModel.loginSuccess) {
            if appleLoginViewModel.loginSuccess, let userData = appleLoginViewModel.userData {
                authViewModel.handleAppleLoginSuccess(userData: userData)
            }
        }
        .foregroundColor(Color("gray_90"))
        .alert("오류", isPresented: .constant(authViewModel.errorMessage != nil)) {
            Button("확인") {
                authViewModel.clearError()
            }
        } message: {
            Text(authViewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    ContentView()
}
