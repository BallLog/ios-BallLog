//
//  DetailHeader.swift
//  balllog
//
//  Created by 전은혜 on 3/21/25.
//

import SwiftUI

struct DetailHeaderView: View {
    var title: String
    var shouldAllowDismiss: Bool?  // 옵셔널 바인딩
    @State private var showModal = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Button(action: {
                // shouldAllowDismiss가 nil이면 true로 간주
                if shouldAllowDismiss ?? true {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showModal = true
                }
            }) {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .foregroundColor(Color("gray_90"))
                    .fontWeight(.semibold)
                    .scaledToFit()
                    .frame(width: 12, height: 21)
            }

            Spacer()

            Text(title)
                .fontWeight(.semibold)
                .font(.system(size: 18))

            Spacer()
        }
        .padding(.horizontal, 25.5)
        .padding(.vertical, 21.25)
        .background(Color.white)
        .sheet(isPresented: $showModal) {
            // 여기에 모달로 보여줄 커스텀 뷰 넣기
            ModalView(
                isPresented: $showModal,
                onConfirmDismiss: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct ModalView: View {
    @Binding var isPresented: Bool
    var onConfirmDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            VStack {
                Spacer()
                VStack(spacing: 12.0) {
                    Text("저장하기")
                        .font(.system(size: 24))
                        .bold()
                    VStack {
                        Text("저장하지 않고 페이지를 벗어날 경우,")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                        Text("지금까지 작성한 내용이 사라집니다.")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                    }
                }
                .foregroundStyle(Color("gray_90"))
                Spacer()
                HStack(spacing: 0.0) {
                    Button("취소") {
                        isPresented = false
                    }
                    .frame(width: 158, height:45)
                    .foregroundStyle(Color("gray_70"))
                    .background(Color("gray_20"))
                    Button("저장") {
                        isPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onConfirmDismiss()
                        }
                    }
                    .frame(width: 158, height:45)
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
