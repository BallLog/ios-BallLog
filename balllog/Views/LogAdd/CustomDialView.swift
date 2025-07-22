//
//  CustomDialView.swift
//  balllog
//
//  Created by 전은혜 on 3/2/25.
//

import SwiftUI

struct CustomDialView: View {
    let placeholder: String
    let suffix: String
    @Binding var selectedValue: String
    
    @State private var focusedValue: String = ""
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Button(action: {
                isSheetPresented = true
            }) {
                Text(selectedValue.isEmpty ? placeholder : selectedValue)
                    .foregroundColor(Color("gray_60"))
                    .font(.system(size: 16))
                    .bold()
            }
            .sheet(isPresented: $isSheetPresented) {
                VStack(spacing: 5.0) {
                    HStack(spacing: 12.0) {
                        Text(suffix)
                        .font(.system(size: 16))
                        .bold()
                        .frame(width: 142.5, height: 215)
                        .clipped()
                        
                        Picker("숫자 선택", selection: $focusedValue) {
                            ForEach(0..<41, id: \.self) { number in
                                Text("\(number)").tag("\(number)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle()) // 다이얼 스타일 적용
                        .frame(width: 142.5, height: 215)
                        .clipped()
                    }
                    Button("선택") {
                        selectedValue = focusedValue
                        isSheetPresented = false
                    }
                    .buttonStyle(CustomButtonStyle())
                    .modifier(DefaultButtonWidth())
                }
                .padding(.vertical, 40.0)
                // iOS 16 이상에서만 동작
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.hidden)
            }
        }
        .font(.system(size: 14))
    }
}

struct CustomDialView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDialView(placeholder: "0", suffix: "우리팀 점수", selectedValue: .constant(""))
            .padding()
            
    }
}

    
