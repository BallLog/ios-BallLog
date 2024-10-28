//
//  SplashView.swift
//  balllog
//
//  Created by 전은혜 on 10/17/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Text("직관을 기록하는")
                .font(.body)
            Text("볼로그")
                .font(.title)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    SplashView()
}
