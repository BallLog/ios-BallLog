//
//  LogEditHeaderView.swift
//  balllog
//
//  Created by 전은혜 on 8/19/25.
//

import SwiftUI

struct LogEditHeaderView: View {
    let hasDataChanged: Bool
    @Binding var showExitConfirmation: Bool
    let dismiss: DismissAction
    
    var body: some View {
        HStack {
            Button(action: {
                if hasDataChanged {
                    showExitConfirmation = true
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text("볼로그 수정")
                .font(.headline)
            
            Spacer()
            
            // 균형을 위한 투명한 버튼
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.clear)
            }
            .disabled(true)
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.white)
    }
}