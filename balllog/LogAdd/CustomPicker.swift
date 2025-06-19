//
//  CustomPicker.swift
//  balllog
//
//  Created by 전은혜 on 1/14/25.
//

import SwiftUI

struct CustomPicker: View {
    let list: [String]
    let placeholder: String
    @Binding var selectedValue: String
    var bigSize: Bool = false
    
    @State private var focusedValue: String = ""
    @State private var isSheetPresented: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Button(action: {
                isSheetPresented = true
            }) {
                HStack (spacing: 4){
                    Text(selectedValue.isEmpty ? placeholder : selectedValue)
                        .foregroundColor(Color("gray_60"))
                        .font(.system(size: bigSize ? 14 : 12))
                        .fontWeight(bigSize ? .bold : .regular)
                    Image("under_triangle")
                        .foregroundColor(Color("gray_60"))
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                VStack(spacing: 5.0) {
                    VStack(spacing: 0.0) {
                        ForEach(list.indices, id: \.self) { idx in
                            Button(action: {
                                focusedValue = list[idx]
                            }) {
                                Text(list[idx])
                                    .font(.system(size: 16))
                                    .foregroundColor(focusedValue == list[idx] ? Color("bc_02_60") : Color("gray_80"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(focusedValue == list[idx] ?  Color("bc_02_10") : nil)
                                
                            }
                            .overlay(
                                idx < list.count - 1 ?
                                Divider()
                                    .foregroundColor(Color("gray_20"))  : nil,
                                alignment: .bottom
                            )
                        }
                    }
                    Button("선택") {
                        selectedValue = focusedValue
                        isSheetPresented = false
                    }
                    .disabled(focusedValue.isEmpty)
                    .buttonStyle(CustomButtonStyle())
                    .modifier(DefaultButtonWidth())
                }
                // iOS 16 이상에서만 동작
                // MARK: 풀화면으로 커지는거는 안되게 할 수 있는지 확인해보기
                .presentationDetents([.fraction(0.8), .large])
                .presentationDragIndicator(.hidden)
            }
        }
        .font(.system(size: 14))
    }
}

struct CustomPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker(list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "구단선택", selectedValue: .constant("KT 위즈"))
            .padding()
            .previewLayout(.sizeThatFits)
        CustomPicker(list: ["기아 타이거즈", "삼성 라이온즈", "LG 트윈스", "두산 베어스", "KT 위즈", "SSG 랜더스", "롯데 자이언츠", "한화 이글스", "NC 다이노스", "키움 히어로즈"], placeholder: "구단선택", selectedValue: .constant(""))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
