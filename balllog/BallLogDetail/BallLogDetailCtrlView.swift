//
//  BallLogDetailCtrlView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//
import SwiftUI

struct BallLogDetailCtrlView: View {
    var onShareTapped: () -> Void = {}
    var onDeleteTapped: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 22) {
            HStack (spacing: 14) {
                VStack (spacing: -1) {
                    Image("share")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("공유")
                        .font(.system(size: 12))
                        .bold()
                }
                .frame(width: 45, height: 45)
                .onTapGesture {
                    onShareTapped()
                }
                
                VStack (spacing: -1) {
                    Image("delete")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("삭제")
                        .font(.system(size: 12))
                        .bold()
                }
                .frame(width: 45, height: 45)
                .onTapGesture {
                    onDeleteTapped()
                }
            }
            VStack {
                Button("수정하기") {
                    // 수정하기
                }
                .buttonStyle(RoundedButtonStyle())
                .modifier(DefaultButtonWidth(width: .infinity))
            }
            .frame(height: 50.0)
        }
        .background(Color.white)
        .padding(.vertical, 12.0)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("gray_30")),
            alignment: .top
        )
        .padding(.horizontal, 20.0)
        .frame(height: 73.0)
        .frame(maxWidth: .infinity)
    }
}

#Preview{
    BallLogDetailCtrlView()
}
