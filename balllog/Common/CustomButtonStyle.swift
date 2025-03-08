//
//  CustomButtonStyle.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .font(.system(size: 16))
            .foregroundColor(isEnabled ? Color.white : Color("gray_40"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isEnabled ? Color("bc_02_50") : Color("gray_20"))
            .cornerRadius(6)
            .disabled(isEnabled)
    }
}


struct GrayBtnStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .font(.system(size: 16))
            .foregroundColor(isEnabled ? Color.white : Color("gray_40"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isEnabled ? Color("gray_40") : Color("gray_20"))
            .cornerRadius(6)
            .disabled(isEnabled)
    }
}

struct DefaultButtonWidth: ViewModifier {
    var width: CGFloat?
    
    func body(content: Content) -> some View {
        content.frame(width: width ?? 330, height: 50) // 기본값 330
    }
}
