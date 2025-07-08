//
//  TeamConfirmView.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import SwiftUI

struct TeamConfirmView: View {
    @Binding var selectedTeam: Team?
    let onConfirm: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            
            VStack {
                Spacer()
                
                VStack(spacing: 8.0) {
                    Text(selectedTeam?.name ?? "선택된 팀 없음")
                        .font(.system(size: 24))
                        .bold()
                    Text("당신은 구단별 특정문구")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                }
                .foregroundStyle(Color("gray_90"))
                
                Spacer()
                
                HStack(spacing: 0.0) {
                    Button("다시선택") {
                        dismiss()
                    }
                    .frame(width: 158, height: 45)
                    .foregroundStyle(Color("gray_70"))
                    .background(Color("gray_20"))
                    
                    Button("시작하기") {
                        onConfirm()
                        dismiss()
                    }
                    .frame(width: 158, height: 45)
                    .foregroundStyle(Color("bc_02_10"))
                    .background(Color("bc_02_60"))
                }
                .font(.system(size: 14))
                .fontWeight(.semibold)
            }
            .frame(width: 316, height: 229)
            .background(Color.white)
            .cornerRadius(11.0)
        }
        .ignoresSafeArea()
        .transition(.opacity)
    }
}
