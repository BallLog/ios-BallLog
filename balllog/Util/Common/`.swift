
//
//  CustomButton.swift
//  balllog
//
//  Created by 전은혜 on 12/29/24.
//

import SwiftUI

struct TeamButtonView: View {
    var body: some View {
        Button(action: viewModel.handleTap) {
            Text(viewModel.title)
                .fontWeight(.bold)
                .font(.system(size: 16))
                .foregroundColor(viewModel.isEnabled ? Color("white") : Color("gray_50"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: width, height: height)
        .background(viewModel.isEnabled ? Color("bc_02_50") : Color("white"))
        .cornerRadius(6)
        .disabled(!viewModel.isEnabled)
    }
}
