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
                    // 최초 로그인인 경우
                    TermsView()
                        .environmentObject(authViewModel)
                    // 최초 로그인 아닌 경우
//                    ServiceView()
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            } else {
                SplashView()
                    .onAppear{
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
        // Apple 로그인 성공 감지
        .onChange(of: appleLoginViewModel.loginSuccess) {
            if appleLoginViewModel.loginSuccess, let userData = appleLoginViewModel.userData {
                authViewModel.handleAppleLoginSuccess(userData: userData)
            }
        }
        .foregroundColor(Color("gray_90"))
    }
}

#Preview {
    ContentView()
}
