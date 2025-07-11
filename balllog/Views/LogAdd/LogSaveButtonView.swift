//
//  LogSaveButtonView.swift
//  balllog
//
//  Created by 전은혜 on 6/19/25.
//

import SwiftUI


struct LogSaveButtonView: View {
    let isFormValid: Bool
    let onSave: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Button("저장") {
                    onSave()
                }
                .buttonStyle(CustomButtonStyle())
                .modifier(DefaultButtonWidth(width: geometry.size.width - 40))
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1.0 : 0.6)
            }
            .frame(height: 80.0)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 8.6, x: 0, y: -1)
        }
        .frame(height: 80.0)
    }
}

#Preview {
    LogAddView()
}
