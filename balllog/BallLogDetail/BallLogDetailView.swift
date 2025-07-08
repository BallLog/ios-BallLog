//
//  BallLogDetail.swift
//  balllog
//
//  Created by 전은혜 on 3/20/25.
//

import SwiftUI

struct BallLogDetailView: View {
    @StateObject private var viewModel = BallLogCreateViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        Spacer().frame(minHeight: 10)
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
                    BallLogDetailCtrlView(
                        onShareTapped: {
                            // 공유 API 호출
                            print("공유 버튼 클릭")
                        },
                        onDeleteTapped: {
                            // 삭제 API 호출
                            print("삭제 버튼 클릭")
                        }
                    )
                }
            }
        }
    }
}


#Preview {
    BallLogDetailView()
}
