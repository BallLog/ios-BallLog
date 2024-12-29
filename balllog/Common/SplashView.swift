//
//  SplashView.swift
//  balllog
//
//  Created by 전은혜 on 10/17/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Image("SplashImage")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
        }
    }
}

#Preview {
    SplashView()
}
