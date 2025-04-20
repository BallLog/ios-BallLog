//
//  CustomInputView.swift
//  balllog
//
//  Created by 전은혜 on 1/12/25.
//

import SwiftUI

struct CustomInputView: View {
    let label: String
    var isArea: Bool = false
    @Binding var text: String
    var placeholder: String = ""
    var hasValidation: Bool = false
    var isError: Bool = false
    var isCorrect: Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10.0) {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color("gray_70"))
                .padding(.leading, 2.0)
            if isArea {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .padding(12)
                        .font(.system(size: 14))
                        .foregroundColor(Color("gray_80"))
                        .frame(height: 134)
                        .scrollContentBackground(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(
                                    (text.isEmpty ? Color("gray_20") : Color.white)
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    hasValidation ?
                                    (isError ? Color("error_50") : (isCorrect ? Color("bc_01_60") : Color("gray_20"))) : text.isEmpty == false ? Color("gray_20") : Color.clear, lineWidth: 1.3)
                        )
                    // Placeholder Text
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.system(size: 14))
                            .foregroundColor(Color("gray_50"))
                            .padding(18)
                    }
                }
                
            } else {
                TextField(placeholder, text: $text)
                    .padding(12)
                    .font(.system(size: 14))
                    .foregroundColor(Color("gray_80"))
                    .background(text.isEmpty ? Color("gray_20") : Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(text.isEmpty == false ? Color("gray_20") : Color.clear, lineWidth: 1.3)
                    )
            }
        }
    }
}

struct CustomInputView_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputView(label: "제목", isArea: true, text: .constant(""), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
        CustomInputView(label: "제목", text: .constant(""), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
