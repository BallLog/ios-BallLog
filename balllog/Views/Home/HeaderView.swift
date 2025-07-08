//
//  HeaderView.swift
//  balllog
//
//  Created by 전은혜 on 6/25/25.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Text("나의 볼로그")
                    .fontWeight(.bold)
                    .foregroundColor(Color("gray_90"))
                Spacer()
                HStack(spacing: 6) {
                    Text("전체")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                    Image(systemName: "chevron.down")
                        .frame(width: 16, height: 16)
                }
                .foregroundColor(Color("gray_50"))
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 28)
            Spacer()
        }
    }
}
