//
//  CustomDialView.swift
//  balllog
//
//  Created by 전은혜 on 3/2/25.
//

import SwiftUI

struct CustomDialView: View {
    let title: String
    let placeholder: String
    @Binding var selectedValue: String
    
    @State private var focusedValue: String = ""
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color("gray_70"))
                .padding(.leading, 2.0)
                        
            Button(action: {
                isSheetPresented = true
            }) {
                HStack {
                    Text(selectedValue.isEmpty ? placeholder : selectedValue)
                        .foregroundColor(selectedValue.isEmpty ? Color("gray_50") : Color("gray_80"))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("gray_40"))
                }
                .padding(.horizontal, 12.0)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(selectedValue.isEmpty ? Color("gray_20") : Color.white)
                .cornerRadius(4).overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(selectedValue.isEmpty == false ? Color("gray_20") : Color.clear, lineWidth: 1.3)
                )
            }
            .sheet(isPresented: $isSheetPresented) {
                VStack(spacing: 5.0) {
                    VStack(spacing: 0.0) {
                        Picker("숫자 선택", selection: $focusedValue) {
                            ForEach(0..<41, id: \.self) { number in
                                Text("\(number)").tag("\(number)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle()) // 다이얼 스타일 적용
                        .frame(width: 285, height: 215)
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
                // MARK: 풀화면으로 커지는거는 안되게 할 수 있는지 확인해보기
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.hidden)
            }
        }
        .font(.system(size: 14))
    }
}

struct CustomDialView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDialView(title: "점수", placeholder: "구단선택", selectedValue: .constant(""))
            .padding()
            
    }
}

    
