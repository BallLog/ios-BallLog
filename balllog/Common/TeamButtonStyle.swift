//
//  File.swift
//  balllog
//
//  Created by Nada on 1/2/25.
//


import Foundation
import SwiftUI

struct TeamButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .font(.system(size: 14))
            .foregroundColor(isEnabled ? Color("bc_02_60") : Color("gray_40"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(width: 160, height: 80)
            .background(isEnabled ? Color("bc_02_05") : Color("white"))
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(isEnabled ? Color("bc_02_60") : Color("gray_40"), lineWidth: 1)
            )
            .disabled(isEnabled)
    }
}

#Preview {
    HStack{
        Button("버튼") {
            print("clilck!")
        }
        .disabled(true)
        .buttonStyle(TeamButtonStyle())
        
        Button("버튼") {
            print("clilck!")
        }
        .buttonStyle(TeamButtonStyle())
    }
}
