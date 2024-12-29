//
//  CheckBoxView.swift
//  balllog
//
//  Created by 전은혜 on 12/20/24.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    let title: String
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? Color("bc_02_60") : Color("gray_40"))
                    .font(.system(size: 24))
                Text(title)
            }
        }
        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
    }
}
