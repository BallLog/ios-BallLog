//
//  LogFormDiaryView.swift
//  balllog
//
//  Created by 전은혜 on 7/22/25.
//

import SwiftUI
import PhotosUI

struct LogFormDiaryView: View {
    @Binding var selectedItems: [PhotosPickerItem]  // 부모 뷰에서 전달된 선택된 이미지 아이템들
    @Binding var diaryContent: String
    @FocusState var isFocused: Bool
    @FocusState var textAreaFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                DotLineInputView()

                PhotoPickerView(selectedItems: $selectedItems)
                
                DotLineInputView()
            }
            
            VStack {
                TextAreaView(text: $diaryContent, placeholder: "직관 소감을 작성해 주세요.")
                    .focused($textAreaFocused)
                    .id("textArea")
            }
            .padding(.horizontal, 14.0)
            .padding(.vertical, 10.0)
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            .onChange(of: textAreaFocused) { _, focused in
                isFocused = focused
            }
        }
    }
}
