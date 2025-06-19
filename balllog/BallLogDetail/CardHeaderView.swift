//
//  CardHeaderView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//
import SwiftUI

struct CardHeaderView: View {
    @EnvironmentObject var globalData: GlobalData

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("2025.04.01")
                    Spacer()
                    Text("잠실야구장")
                }.font(.system(size: 10))

                HStack {
                    HStack(spacing: 6) {
                        Text("롯데 자이언츠")
                        Text("vs").bold()
                        Text("두산 베어스")
                    }
                    Spacer()
                    HStack(spacing: 3) {
                        Text("0")
                        Text(":" ).bold()
                        Text("0")
                    }
                }.font(.system(size: 14))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
        }
    }
}

#Preview {
    BallLogDetailView()
}
