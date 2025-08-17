//
//  ShareThemeView.swift
//  balllog
//
//  Created by 전은혜 on 8/17/25.
//

import SwiftUI

struct ShareThemeView: View {
    @Binding var selectedTheme: Int
    let index: Int
    let themeImage: UIImage?
    
    var body: some View {
        VStack(spacing: 6) {
            Group {
                if let themeImage = themeImage {
                    Image(uiImage: themeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray.opacity(0.3))
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(selectedTheme == index ? Color("bc_02_50") : Color.clear, lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 0)
            Text("웅원팀 컬러 0\(index + 1)")
                .font(.system(size: 10))
                .foregroundColor(selectedTheme == index ? Color("bc_02_50") : Color("gray_90"))
                .fontWeight(selectedTheme == index ? .semibold : .regular)
        }
    }
}

#Preview {
    ShareThemeView(selectedTheme: .constant(0), index: 0, themeImage: nil)
}
