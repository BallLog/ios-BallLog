//
//  AddBallLogView.swift
//  balllog
//
//  Created by 전은혜 on 5/8/25.
//

import SwiftUI

struct AddBallLogView: View {
    var body: some View {
        NavigationLink(destination: LogAddView())  {
            VStack(spacing: 6) {
                VStack(spacing: 2) {
                    Image("log_add_gray")
                    Text("볼로그 추가")
                        .fontWeight(.bold)
                        .foregroundColor(Color("gray_60"))
                }
                Text("나의 직관일기를 추가해주세요!")
                    .fontWeight(.light)
                    .font(.system(size: 12))
                    .foregroundColor(Color("gray_60"))
            }
            .frame(width: 227, height: 280)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 10.3, x: 0, y: 0)
        }
    }
}
