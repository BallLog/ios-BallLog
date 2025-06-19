//
//  ExitConfirmView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI

struct ExitConfirmModal: View {
    let onStay: () -> Void
    let onExit: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    VStack {
                        Text("작성중인 내용이 있습니다.")
                        Text("나가시겠습니까?")
                    }
                    .font(.system(size: 20))
                    .bold()
                    VStack {
                        Text("저장하지 않고 페이지를 벗어날 경우,")
                        Text("지금까지 작성한 내용이 사라집니다.")
                    }
                    .font(.system(size: 14))
                    .fontWeight(.light)
                }
                .foregroundStyle(Color("gray_90"))
                
                Spacer()
                
                HStack(spacing: 0.0) {
                    Button("홈으로") {
                        onExit()
                        dismiss()
                    }
                    .frame(width: 158, height: 50)
                    .foregroundStyle(Color("gray_70"))
                    .background(Color("gray_20"))
                    
                    Button("머무르기") {
                        onStay()
                        dismiss()
                    }
                    .frame(width: 158, height: 50)
                    .foregroundStyle(Color("bc_02_10"))
                    .background(Color("bc_02_50"))
                }
                .font(.system(size: 14))
                .fontWeight(.semibold)
            }
            .frame(width: 316, height: 247)
            .background(Color.white)
            .cornerRadius(11.0)
        }
        .ignoresSafeArea()
        .transition(.opacity)
    }
}

#Preview {
    LogAddView()
}
