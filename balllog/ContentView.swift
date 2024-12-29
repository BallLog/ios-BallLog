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
    
    var body: some View {
        Group {
            if showMainView {
                if authViewModel.isLoggedIn {
                    HomeView()
                } else {
                    LoginView()
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
        .foregroundColor(Color("gray_90"))
    }
}

#Preview {
    ContentView()
}
