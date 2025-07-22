//
//  AppleLoginView.swift
//  balllog
//
//  Created by 전은혜 on 7/7/25.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    @StateObject private var viewModel = AppleLoginViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                // 커스텀 디자인 (보이는 부분)
                HStack {
                    Image("AppleLogo")
                    Spacer()
                    Text("Apple로 로그인")
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                        .foregroundColor(Color("gray_90"))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16.0)
                .padding(.horizontal, 25.0)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color("gray_90"), lineWidth: 1)
                        .background(Color.white)
                )
                
                // 실제 Apple 버튼 (투명하게 만들어서 터치만 받기)
                SignInWithAppleButton(
                    onRequest: viewModel.handleAppleSignInRequest,
                    onCompletion: viewModel.handleAppleSignInCompletion
                )
                .opacity(0.001) // 거의 투명하게 만들기 (완전히 0으로 하면 터치가 안됨)
                .frame(maxWidth: .infinity)
                .frame(height: 56) // 커스텀 버튼과 같은 높이
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .alert("오류", isPresented: .constant(viewModel.error != nil)) {
            Button("확인") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
}

#Preview {
    AppleLoginView()
        .environmentObject(AuthViewModel())
}
