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
            LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: Color(hex: "#6995E7"), location: 0.0), // 0% 지점에서 첫 번째 색상
                    Gradient.Stop(color: Color(hex: "#3D00A6"), location: 1.0)  // 100% 지점에서 두 번째 색상
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
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
