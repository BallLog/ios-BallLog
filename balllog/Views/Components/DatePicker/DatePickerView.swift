//
//  DatePickerView.swift
//  balllog
//
//  Created by 전은혜 on 5/18/25.
//

import SwiftUI

struct DatePickerView: View {
    @State private var isSheetPresented: Bool = false
    @Binding var selectedDate: Date?
    
    var body: some View {
            VStack {
                Button(action: {
                    isSheetPresented.toggle()
                }) {
                    HStack (spacing: 4) {
                        Text(selectedDate != nil ? formattedDate(selectedDate!) : "경기 날짜")
                            .foregroundColor(Color("gray_60"))
                            .font(.system(size: 14))
                            .bold()
                        Image("under_triangle")
                            .foregroundColor(Color("gray_60"))
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                CustomDatePickerView(
                    selectedDate: $selectedDate,
                    isPresented: $isSheetPresented
                )
                .presentationDetents([.medium])
            }
        }

        func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 M월 d일"
            return formatter.string(from: date)
        }
}

struct DatePickerView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedDate: Date? = nil

        var body: some View {
            DatePickerView(selectedDate: $selectedDate)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
