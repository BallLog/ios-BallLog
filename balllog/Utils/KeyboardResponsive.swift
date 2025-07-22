//
//  KeyboardResponsive.swift
//  balllog
//
//  Created by 전은혜 on 7/2/25.
//

import SwiftUI
import UIKit

// 키보드 높이를 감지하는 ObservableObject
class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var isKeyboardVisible = false
    
    init() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            self.handleKeyboardShow(notification)
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { notification in
            self.handleKeyboardHide(notification)
        }
    }
    
    private func handleKeyboardShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            self.keyboardHeight = keyboardFrame.height
            self.isKeyboardVisible = true
        }
    }
    
    private func handleKeyboardHide(_ notification: Notification) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.keyboardHeight = 0
            self.isKeyboardVisible = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct KeyboardResponsiveScrollView<Content: View>: View {
    let content: Content
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        content
                        
                        // 키보드 높이만큼 여백 추가
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: keyboardObserver.keyboardHeight)
                            .id("bottomPadding")
                    }
                }
                .onChange(of: keyboardObserver.isKeyboardVisible) { _, isVisible in
                    if isVisible {
                        // 키보드가 나타나면 맨 아래로 스크롤
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("bottomPadding", anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

