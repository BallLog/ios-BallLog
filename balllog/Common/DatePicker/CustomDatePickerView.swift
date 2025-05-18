//
//  CustomDatePickerView.swift
//  balllog
//
//  Created by 전은혜 on 5/18/25.
//

import SwiftUI

struct CustomDatePickerView: View {
    @Binding var selectedDate: Date?
    @Binding var isPresented: Bool

    @State private var currentMonth: Date = Date()
    private let calendar = Calendar.current
    private let minDate = Calendar.current.date(from: DateComponents(year: 2015, month: 1, day: 1))!
    private let today = Date()

    var body: some View {
        VStack(spacing: 14) {
            // 🔼 Header: 년/월 표시 + 다이얼 버튼 + 화살표
            HStack(alignment: .center) {
                HStack(alignment: .center, spacing: 7.0) {
                    formattedYearMonthText(currentMonth)
                    Button(action: { /* 다이얼 띄우기 */ }) {
                        Image("left-arrow")
                    }
                }
                .foregroundStyle(Color("gray_80"))
                .frame(height: 40.0)

                Spacer()

                HStack(alignment: .center, spacing: 15.0) {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundStyle(Color("gray_80"))
                    .disabled(isBeforeMinMonth())

                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(isCurrentMonth() ? Color("gray_40") : Color("gray_80"))
                    .disabled(isCurrentMonth())
                }
            }
            .padding(.horizontal, 28.0)

            // 📅 Calendar Grid
            CalendarGridView(
                month: currentMonth,
                selectedDate: $selectedDate,
                today: today,
                minDate: minDate
            )
            .padding(.horizontal, 28.0)

            // ✅ 선택 버튼
            VStack {
                Button("선택") {
                    isPresented = false
                }
                .buttonStyle(CustomButtonStyle())
            }
            .padding(.top, 3.0)
            .padding(.horizontal, 20.0)
            .frame(height: 50)
        }
        .padding(.top, 16.0)
    }

    func formattedYearMonthText(_ date: Date) -> some View {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)

        return Text(String(year))
            .bold()
            + Text("년 ")
            + Text("\(month)")
            .bold()
            + Text("월")
    }

    func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentMonth),
           newDate >= minDate {
            currentMonth = newDate
        }
    }

    func nextMonth() {
        if !isCurrentMonth() {
            if let newDate = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
                currentMonth = newDate
            }
        }
    }

    func isBeforeMinMonth() -> Bool {
        calendar.compare(currentMonth, to: minDate, toGranularity: .month) != .orderedDescending
    }

    func isCurrentMonth() -> Bool {
        calendar.isDate(currentMonth, equalTo: today, toGranularity: .month)
    }
}

#Preview {
    CustomDatePickerPreviewWrapper()
}

struct CustomDatePickerPreviewWrapper: View {
    @State private var selectedDate: Date? = nil
    @State private var isPresented: Bool = true

    var body: some View {
        CustomDatePickerView(
            selectedDate: $selectedDate,
            isPresented: $isPresented
        )
    }
}
