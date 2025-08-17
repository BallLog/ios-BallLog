//
//  DeleteConfirmationModal.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//


import SwiftUI

struct DeleteConfirmationModal: View {
    @ObservedObject var viewModel: BallLogDetailViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    VStack {
                        Text("삭제하기")
                    }
                    .font(.system(size: 20))
                    .bold()
                    VStack {
                        Text("해당 볼로그를 삭제 하시겠습니까?")
                    }
                    .font(.system(size: 14))
                    .fontWeight(.light)
                }
                .foregroundStyle(Color("gray_90"))
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView("삭제 중...")
                        .padding()
                } else {
                    HStack(spacing: 0.0) {
                        Button("취소") {
                            viewModel.hideDeleteConfirmation()
                        }
                        .frame(width: 158, height: 50)
                        .foregroundStyle(Color("gray_70"))
                        .background(Color("gray_20"))
                        
                        Button("삭제하기") {
                            Task {
                                await viewModel.deleteBallLog()
                            }
                        }
                        .frame(width: 158, height: 50)
                        .foregroundStyle(Color("bc_02_10"))
                        .background(Color("bc_02_50"))
                    }
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                }
            }
            .frame(width: 316, height: 247)
            .background(Color.white)
            .cornerRadius(11.0)
        }
        .ignoresSafeArea()
        .transition(.opacity)
    }
}
