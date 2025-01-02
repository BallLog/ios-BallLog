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
            .foregroundColor(isEnabled ? Color("white") : Color("gray_40"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(width: 330, height: 50)
            .background(isEnabled ? Color("bc_02_50") : Color("gray_20"))
            .cornerRadius(6)
            .disabled(isEnabled)
    }
}
