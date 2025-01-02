//
//  CheckboxToggleStyle.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle() // toggle State
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? Color("bc_02_60") : Color("gray_40"))
                    .font(.system(size: 24))
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
        .disabled(!isEnabled)
    }
}
