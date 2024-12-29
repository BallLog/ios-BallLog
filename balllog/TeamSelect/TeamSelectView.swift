//
//  TermsView.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import SwiftUI

struct TeamSelectView: View {
    @StateObject private var termsViewModel: TermsViewModel
    
    init(termsViewModel: TermsViewModel = TermsViewModel()) {
        _termsViewModel = StateObject(wrappedValue: termsViewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24.0) {
                VStack(alignment: .leading, spacing: 4.0) {
                    Text("응원구단 선택")
                        .bold()
                        .font(.system(size: 24))
                        .lineSpacing(36)
                    Text("내가 응원하는 구단을 선택 해주세요")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .lineSpacing(21)
                }
                .padding(.horizontal, 30.0)
                VStack(alignment: .leading, spacing: 5.0) {
                    HStack {
                        
                    }
                }
                .padding(.horizontal, 20.0)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            .padding(.top, 56.0)
            Spacer()
            VStack {
                 
            }
            .navigationDestination(isPresented: $termsViewModel.shouldNavigate) {
                HomeView()
            }
            .padding(.bottom, 16.0)
        }
    }
}

#Preview {
    TeamSelectView()
}
