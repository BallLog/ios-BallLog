//
//  DetailHeader.swift
//  balllog
//
//  Created by 전은혜 on 3/21/25.
//

import SwiftUI

struct DetailHeaderView: View {
    var title: String
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 동작을 위한 환경 변수

    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss() // 현재 화면을 닫고 이전 화면으로 돌아감
            }) {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .foregroundColor(Color("gray_90"))
                    .fontWeight(.semibold)
                    .scaledToFit()
                    .frame(width: 12, height: 21)
            }
            Spacer()
            Text(title)
                .fontWeight(.semibold)
                .font(.system(size: 18))
            Spacer()
        }
        .padding(.horizontal, 25.5)
        .padding(.vertical, 21.25)
        .background(Color.white)
    }
}
