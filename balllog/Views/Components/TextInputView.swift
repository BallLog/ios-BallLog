//
//  TextInputView.swift
//  balllog
//
//  Created by 전은혜 on 4/28/25.
//

import SwiftUI

struct TextInputView: View {
    @Binding var text: String
    var placeholder: String = ""
    var maxLength: Int?
    var fontSize: CGFloat = 14
    var fontWeight: Font.Weight = .regular
    
    var body: some View {
        ZStack (alignment: .leading) {
            TextField("", text: $text)
                .font(.system(size: fontSize))
                .fontWeight(fontWeight)
                .foregroundColor(Color("gray_60"))
                .background(Color.white)
                .cornerRadius(6)
                .onChange(of: text) { _, newValue in
                    // 최대 길이 제한 (maxLength가 설정되었을 때만)
                    if let maxLength = maxLength, newValue.count > maxLength {
                        text = String(newValue.prefix(maxLength))
                    }
                }
            if text.isEmpty {
                HStack(spacing: 8) {
                    Image("write")
                    Text(placeholder)
                        .foregroundColor(Color("gray_60"))
                        .fontWeight(fontWeight)
                        .font(.system(size: fontSize))
                    Spacer()
                }
                .allowsHitTesting(false) // 플레이스홀더 탭 방지
            }
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(text: .constant(""), placeholder: "제목을 입력해주세요")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
