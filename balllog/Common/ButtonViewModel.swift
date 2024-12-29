//
//  CustomButton.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
//

import SwiftUI
import Combine
import Foundation

class ButtonViewModel: ObservableObject {
    @Published var isEnabled: Bool
    let title: String
    let action: () -> Void
    
    init(
        title: String,
        isEnabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    func handleTap() {
        guard isEnabled else { return }
        action()
    }
}
