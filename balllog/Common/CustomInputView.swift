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
                        .frame(maxHeight: 125)
                        .scrollContentBackground(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color("gray_20"))
                        )
                    // Placeholder Text
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.system(size: 14))
                            .foregroundColor(Color("gray_50"))
                            .padding(12)
                    }
                }
                
            } else {
                TextField(placeholder, text: $text)
                    .padding(12)
                    .font(.system(size: 14))
                    .foregroundColor(text.isEmpty ? Color("gray_50") : Color("gray_80"))
                    .background(Color("gray_20"))
                    .cornerRadius(6)
            }
        }
    }
}

struct CustomInputView_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputView(label: "제목", isArea: true, text: .constant("경기 개그치하네"), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
        CustomInputView(label: "제목", text: .constant("제목"), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
