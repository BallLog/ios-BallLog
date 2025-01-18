//
//  CustomTextEditorView.swift
//  balllog
//
//  Created by 전은혜 on 1/12/25.
//

import SwiftUI

struct CustomTextEditorView: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10.0) {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color("gray_70"))
                .padding(.leading, 2.0)
            TextEditor(placeholder, text: $text)
                .12)
                .font(.system(size: 14))
                .foregroundColor(text.isEmpty ? Color("gray_50") : Color("gray_80"))
                .background(Color("gray_20"))
                .cornerRadius(6)
        }
    }
}

struct CustomTextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextEditorView(label: "제목", text: .constant(""), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
        CustomTextEditorView(label: "제목", text: .constant("제목"), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
