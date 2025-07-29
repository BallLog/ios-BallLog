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
    
    private let maxLength = 150 // API 스펙에 맞춘 최대 길이
    
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image("write")
                .padding(.top, 12)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(.custom("OwnglyphEuiyeonChae", size: 20))
                    .scrollContentBackground(.hidden)
                    .onChange(of: text) { _, newValue in
                        // 최대 길이 제한
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
                
                // Placeholder Text (기존 스타일 유지)
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("OwnglyphEuiyeonChae", size: 20))
                        .foregroundColor(Color("gray_60"))
                    .padding(8)
                }
            }
            .frame(height: 173)
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
