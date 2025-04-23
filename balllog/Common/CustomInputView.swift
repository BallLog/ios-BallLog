//
//  CustomInputView.swift
//  balllog
//
//  Created by 전은혜 on 1/12/25.
//

import SwiftUI

struct CustomInputView: View {
    let label: String?
    var isArea: Bool = false
    @Binding var text: String
    var placeholder: String = ""
    var hasValidation: Bool = false
    var isError: Bool = false
    var isCorrect: Bool = false
    var maxLength: Int?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10.0) {
            if(label != nil){
                Text(label ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(Color("gray_70"))
                    .padding(.leading, 2.0)
            }
            if isArea {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .padding(12)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white)
                        .frame(height: 134)
                        .scrollContentBackground(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(
                                    (Color.white)
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    hasValidation ?
                                    (isError ? Color("error_50") : (isCorrect ? Color("bc_01_60") : Color("gray_30"))) : Color("gray_30"), lineWidth: 1.3)
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
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(isError ? Color("error_50") : isCorrect ? Color("bc_01_60") : Color("gray_30"), lineWidth: 1.3)
                    )
                    .onChange(of: text) { _, newValue in
                        // 최대 길이 제한 (maxLength가 설정되었을 때만)
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
        }
    }
}

struct CustomInputView_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputView(label: "제목", isArea: true, text: .constant(""), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
        CustomInputView(label: "", text: .constant(""), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
