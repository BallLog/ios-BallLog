//
//  CalendarGridView.swift
//  balllog
//
//  Created by 전은혜 on 5/18/25.
//

import SwiftUI

struct CalendarGridView: View {
    let month: Date
    @Binding var selectedDate: Date?
    let today: Date
    let minDate: Date

    var body: some View {
        let days = makeDaysInMonth(for: month)
        let calendar = Calendar.current

        GeometryReader { geo in
            let daywidth = geo.size.width / 7
            
            VStack(spacing: 4) {
                // 한글 요일 배열 (일~토)
                let koreanWeekdays = ["일", "월", "화", "수", "목", "금", "토"]

                HStack(spacing: 0) {
                    ForEach(koreanWeekdays, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // 날짜 그리드 (7일씩 나누기)
                let rows = days.chunked(into: 7)
                
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: 0) {
                        ForEach(rows[rowIndex], id: \.self) { date in
                            if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                Button(action: {
                                    selectedDate = date
                                }) {
                                    Text("\(calendar.component(.day, from: date))")
                                        .font(.system(size: 14))
                                        .fontWeight(isDisabled(date) ? .light : .regular)
                                        .frame(width: daywidth, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(isSelected(date) ? Color("bc_02_20") : Color.clear)
                                        )
                                        .foregroundColor(isDisabled(date)
                                                         ? Color("gray_50")
                                                         : (isSelected(date) ? Color("bc_02_70") : Color("gray_100")))
                                }
                                .disabled(isDisabled(date))
                            } else {
                                // 빈 칸: 투명한 영역, 터치 안됨
                                Color.white
                                    .frame(width: daywidth, height: 40)
                            }
                        }
                    }
                }
            }
        }
    }

    func isDisabled(_ date: Date) -> Bool {
        return date > today || date < minDate
    }
    
    func isSelected(_ date: Date) -> Bool {
        guard let selected = selectedDate else { return false }
        return Calendar.current.isDate(selected, inSameDayAs: date)
    }

    func makeDaysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        guard let monthRange = calendar.range(of: .day, in: .month, for: date),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }

        let weekdayOffset = calendar.component(.weekday, from: firstOfMonth) - calendar.firstWeekday
        let startOffset = weekdayOffset < 0 ? 7 + weekdayOffset : weekdayOffset

        var days: [Date] = []

        // 1. 앞쪽 빈칸 포함하여 날짜 채우기
        for dayOffset in 0..<(monthRange.count + startOffset) {
            if let day = calendar.date(byAdding: .day, value: dayOffset - startOffset, to: firstOfMonth) {
                days.append(day)
            }
        }

        // 2. 뒷쪽 빈칸 채우기 (7의 배수가 되도록)
        let remainder = days.count % 7
        if remainder != 0 {
            let additional = 7 - remainder
            if let lastDate = days.last {
                for i in 1...additional {
                    if let date = calendar.date(byAdding: .day, value: i, to: lastDate) {
                        days.append(date)
                    }
                }
            }
        }
    
        return days
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        var index = 0
        while index < count {
            let end = Swift.min(index + size, count)
            chunks.append(Array(self[index..<end]))
            index += size
        }
        return chunks
    }
}

#Preview {
    CalendarGridViewPreviewWrapper()
}

struct CalendarGridViewPreviewWrapper: View {
    @State private var selectedDate: Date? = nil

    var body: some View {
        CalendarGridView(
            month: Date(), // 이번 달 기준
            selectedDate: $selectedDate,
            today: Date(),
            minDate: Calendar.current.date(from: DateComponents(year: 2015, month: 1, day: 1))!
        )
    }
}
