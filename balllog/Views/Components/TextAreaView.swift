//
//  TextAreaView.swift
//  balllog
//
//  Created by 전은혜 on 4/28/25.
//

import SwiftUI

struct TextAreaView: View {
    @Binding var text: String
    var placeholder: String = ""
    @FocusState private var isFocused: Bool
    
    private let maxLength = 150 // API 스펙에 맞춘 최대 길이
    
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image("write")
                .padding(.top, 12)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(.custom("OwnglyphEuiyeonChae", size: 20))
                    .scrollContentBackground(.hidden)
                    .focused($isFocused)
                    .onChange(of: text) { _, newValue in
                        // 최대 길이 제한
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
                    .onTapGesture {
                        // TextEditor 내부 탭 시 포커스 보장
                        if !isFocused {
                            isFocused = true
                        }
                    }
                
                // Placeholder Text (기존 스타일 유지)
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("OwnglyphEuiyeonChae", size: 20))
                        .foregroundColor(Color("gray_60"))
                    .padding(8)
                    .allowsHitTesting(false) // 플레이스홀더 탭 방지
                    .onTapGesture {
                        isFocused = true
                    }
                }
            }
            .frame(height: 173)
            .background(
                // 포커스 상태를 시각적으로 표시 (선택사항)
                RoundedRectangle(cornerRadius: 0)
                    .stroke(isFocused ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct TextAreaView_Previews: PreviewProvider {
    static var previews: some View {
        TextAreaView(text: .constant(""), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
