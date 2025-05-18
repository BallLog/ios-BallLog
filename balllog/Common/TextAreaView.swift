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
                .font(.custom("OwnglyphEuiyeonChae", size: 16))
                .scrollContentBackground(.hidden)
                .padding(4)
            // Placeholder Text
            if text.isEmpty {
                Text(placeholder)
                    .font(.custom("OwnglyphEuiyeonChae", size: 16))
                    .foregroundColor(Color("gray_50"))
                    .padding(10)
            }
        }
        .frame(height: 124)
        .onAppear{
            for family in UIFont.familyNames {
                print("Font family: \(family)")
                for name in UIFont.fontNames(forFamilyName: family) {
                    print("    Font name: \(name)")
                }
            }

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
