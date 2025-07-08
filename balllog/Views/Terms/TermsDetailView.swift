//
//  TermsDetailView.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import SwiftUI

struct TermsDetailView: View {
    @StateObject private var viewModel: TermsDetailViewModel
    
    init(contentType: TermsDetailViewModel.ContentType) {
        self._viewModel = StateObject(wrappedValue: TermsDetailViewModel(contentType: contentType))
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8.0) {
                Text(viewModel.contentType.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 14.0))
                
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("약관 내용을 불러오는 중...")
                        Spacer()
                    }
                } else {
                    ScrollView {
                        Text(viewModel.termsContent)
                            .fontWeight(.light)
                            .font(.system(size: 10.0))
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(Color("gray_90"))
            .frame(maxWidth: .infinity)
            .padding(.top, 75.0)
            .padding([.leading, .bottom, .trailing], 20.0)
            
            VStack {
                DetailHeaderView(title: viewModel.contentType.title)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await viewModel.loadContent()
            }
        }
        .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("확인") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
