//
//  BallLogDetail.swift
//  balllog
//
//  Created by 전은혜 on 3/20/25.
//

import SwiftUI

struct BallLogDetailView: View {
    @StateObject private var viewModel = LogAddViewModel()
    @EnvironmentObject var globalData: GlobalData

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        Spacer().frame(minHeight: 8)
                        BallLogCardView(viewModel: viewModel)
                        Spacer().frame(minHeight: 22)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 73)
                    .navigationBarBackButtonHidden(true)
                }

                VStack {
                    DetailHeaderView(title: "볼로그")
                    Spacer()
                }
            }
        }
    }
}


#Preview {
    BallLogDetailView()
}
