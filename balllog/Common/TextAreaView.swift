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
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.custom("OwnglyphEuiyeonChae", size: 20))
                .scrollContentBackground(.hidden)
            // Placeholder Text
            if text.isEmpty {
                HStack(alignment: .center, spacing: 6) {
                    Image("write")
                    Text(placeholder)
                        .font(.custom("OwnglyphEuiyeonChae", size: 20))
                        .foregroundColor(Color("gray_60"))
                }
                .padding(8)
            }
        }
        .frame(height: 173)
    }
}

struct TextAreaView_Previews: PreviewProvider {
    static var previews: some View {
        TextAreaView(text: .constant(""), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
