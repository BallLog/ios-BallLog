//
//  KeyboardAvoidance.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import SwiftUI
import UIKit

// 키보드 높이를 추적하는 ObservableObject
class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    @Published var isKeyboardVisible: Bool = false
    
    private var notificationCenter: NotificationCenter
    
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(
            self,
            selector: #selector(keyBoardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyBoardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc private func keyBoardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            withAnimation(.easeInOut(duration: 0.3)) {
                self.currentHeight = keyboardHeight
                self.isKeyboardVisible = true
            }
        }
    }
    
    @objc private func keyBoardWillHide(notification: Notification) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.currentHeight = 0
            self.isKeyboardVisible = false
        }
    }
}

// 키보드를 피하는 커스텀 뷰 모디파이어
struct KeyboardAvoidingModifier: ViewModifier {
    @StateObject private var keyboard = KeyboardResponder()
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboard.currentHeight)
            .animation(.easeInOut(duration: 0.3), value: keyboard.currentHeight)
    }
}

extension View {
    func keyboardAvoiding() -> some View {
        self.modifier(KeyboardAvoidingModifier())
    }
}
