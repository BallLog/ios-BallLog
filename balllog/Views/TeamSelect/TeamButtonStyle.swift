//
//  TeamButtonStyle.swift
//  balllog
//
//  Created by 전은혜 on 1/2/25.
//

import Foundation
import SwiftUI

enum ButtonState {
    case selected
    case nonselected
}

struct TeamButtonStyle: ButtonStyle {
    let state: ButtonState
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .font(.system(size: 14))
            .foregroundColor(state == .selected ? Color("bc_02_60") : Color("gray_40"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(width: 160, height: 80)
            .background(state == .selected ? Color("bc_02_05") : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(state == .selected ? Color("bc_02_60") : Color("gray_40"), lineWidth: 1)
            )
    }
}

#Preview {
    HStack{
        Button("버튼") {
            print("clilck!")
        }
        .buttonStyle(TeamButtonStyle(state: .selected))
        
        Button("버튼") {
            print("clilck!")
        }
        .buttonStyle(TeamButtonStyle(state: .nonselected))
    }
}
