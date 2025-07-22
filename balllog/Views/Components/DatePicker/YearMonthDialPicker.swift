//
//  YearMonthDialPicker.swift
//  balllog
//
//  Created by 전은혜 on 7/22/25.
//

import SwiftUI

struct YearMonthDialPicker: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    @State private var focusedYear: Int
    @State private var focusedMonth: Int
    
    private let calendar = Calendar.current
    private let years: [Int]
    private let months = Array(1...12)
    
    init(selectedDate: Binding<Date>, isPresented: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._isPresented = isPresented
        
        let currentDate = selectedDate.wrappedValue
        let calendar = Calendar.current
        
        self._focusedYear = State(initialValue: calendar.component(.year, from: currentDate))
        self._focusedMonth = State(initialValue: calendar.component(.month, from: currentDate))
        
        // 2015년부터 현재 년도까지
        let currentYear = calendar.component(.year, from: Date())
        self.years = Array(2015...currentYear)
    }
    
    var body: some View {
        VStack(spacing: 5.0) {
            VStack(spacing: 0.0) {
                HStack(spacing: 0) {
                    // 년도 피커
                    Picker("년도 선택", selection: $focusedYear) {
                        ForEach(years, id: \.self) { year in
                            Text("\(String(year))년")
                                .font(.system(size: 16))
                                .tag(year)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 142.5, height: 215)
                    .clipped()
                    
                    // 월 피커
                    Picker("월 선택", selection: $focusedMonth) {
                        ForEach(months, id: \.self) { month in
                            Text("\(month)월")
                                .font(.system(size: 16))
                                .tag(month)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 142.5, height: 215)
                    .clipped()
                }
            }
            .frame(width: 285, height: 215)
            .clipped()
            
            HStack(spacing: 12) {
                Button("취소") {
                    isPresented = false
                }
                .frame(height: 50)
                .buttonStyle(GrayBtnStyle())
                
                Button("확인") {
                    updateSelectedDate()
                    isPresented = false
                }
                .frame(height: 50)
                .buttonStyle(CustomButtonStyle())
            }
            .padding(.horizontal, 20.0)
        }
        .padding(.vertical, 40.0)
    }
    
    private func updateSelectedDate() {
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.year = focusedYear
        components.month = focusedMonth
        
        // 선택한 년/월에서 유효하지 않은 일자인 경우 해당 월의 마지막 날로 조정
        if let newDate = calendar.date(from: components) {
            selectedDate = newDate
        } else {
            // 예: 2월 30일 같은 경우, 2월의 마지막 날로 설정
            components.day = 1
            if let firstDayOfMonth = calendar.date(from: components),
               let lastDayOfMonth = calendar.dateInterval(of: .month, for: firstDayOfMonth)?.end.addingTimeInterval(-1) {
                selectedDate = lastDayOfMonth
            }
        }
    }
}

#Preview {
    YearMonthDialPickerWrapper()
}

struct YearMonthDialPickerWrapper: View {
    @State private var selectedDate = Date()
    @State private var isPresented = true
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            if isPresented {
                YearMonthDialPicker(
                    selectedDate: $selectedDate,
                    isPresented: $isPresented
                )
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 40)
            }
        }
    }
}
