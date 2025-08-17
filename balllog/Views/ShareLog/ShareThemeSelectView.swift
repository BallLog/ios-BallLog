//
//  ShareThemeSelectView.swift
//  balllog
//
//  Created by 전은혜 on 8/17/25.
//

import SwiftUI

struct ShareThemeSelectView: View {
    @Binding var selectedTheme: Int
    let themeImages: [UIImage]
    let onThemeSelected: (Int) -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    Button(action: {
                        selectedTheme = index
                        onThemeSelected(index)
                    }) {
                        ShareThemeView(
                            selectedTheme: $selectedTheme,
                            index: index,
                            themeImage: index < themeImages.count ? themeImages[index] : nil
                        )
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 22)
        }
        .background(Color.white)
    }
}

#Preview {
    ShareThemeSelectView(
        selectedTheme: .constant(0),
        themeImages: [],
        onThemeSelected: { _ in }
    )
}
