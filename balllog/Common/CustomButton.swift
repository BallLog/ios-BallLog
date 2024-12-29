//
//  CustomButton.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
//

import SwiftUI

struct CustomButton: View {
    @StateObject private var viewModel: ButtonViewModel
    
    private let width: CGFloat
    private let height: CGFloat
    
    init(
        title: String,
        isEnabled: Bool = true,
        width: CGFloat = 330,
        height: CGFloat = 50,
        action: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: ButtonViewModel(
                title: title,
                isEnabled: isEnabled,
                action: action
            )
        )
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Button(action: viewModel.handleTap) {
            Text(viewModel.title)
                .fontWeight(.bold)
                .font(.system(size: 16))
                .foregroundColor(viewModel.isEnabled ? Color("white") : Color("gray_40"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: width, height: height)
        .background(viewModel.isEnabled ? Color("bc_02_50") : Color("gray_20"))
        .cornerRadius(6)
        .disabled(!viewModel.isEnabled)
    }
}
