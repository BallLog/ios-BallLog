//
//  ContentView.swift
//  balllog
//
//  Created by 전은혜 on 10/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainView = false
    
    var body: some View {
        if showMainView {
            LoginView()
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
}

#Preview {
    ContentView()
}
