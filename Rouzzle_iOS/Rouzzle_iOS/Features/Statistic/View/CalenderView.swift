//
//  CalendarView.swift
//  Rouzzle_iOS
//
//  Created by 김동경 on 3/2/25.
//

import SwiftUI

struct CalendarView: View {
    @Binding var month: Date
    let selectedRoutine: RoutineItem
    let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
    
    var body: some View {
        VStack {
            headerView
            calendarGridView
            Spacer()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .center) {
            HStack {
                ForEach(weekdaySymbols.indices, id: \.self) { index in
                    Text(weekdaySymbols[index].uppercased())
                        .foregroundStyle(color(for: index))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var calendarGridView: some View {
        /// 현재 월에 존재하는 일 수
        let daysInMonth: Int = numberOfDays(in: month)
        /// 현재 달의 첫 날이 속한 요일을 0부터 시작하는 인덱스로 변환  = 3월 1일 토요일이므로 6 반환
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        /// 이전 달의 총 일 수
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        /// 현재 달의 날짜와 앞쪽의 빈 칸(첫 주의 여백)을 모두 포함하여 몇 행(row)이 필요한지 계산
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        /// 그리드 전체 셀 수에서 현재 달의 날짜와 첫 주 빈 칸을 뺀 나머지 (다음 달의 보충 날짜)
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if(index > -1 && index < daysInMonth) {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        
                        let hasCompleteHistory = selectedRoutine.history.first { history in
                            Calendar.current.isDate(history.date, inSameDayAs: date)
                        }
                    
                        ZStack {
                            if let color = hasCompleteHistory?.rateColor {
                                Circle()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(color)
                            }
                            Text("\(day)")
                                .foregroundStyle(hasCompleteHistory != nil ? .white : .primary)
                                .lineLimit(1)
                                .padding(.vertical, 12)
                        }
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        Text("\(day)")
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                            .padding(.vertical, 12)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

private extension CalendarView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
}

/// 달력에 필요한 함수들 extension
private extension CalendarView {
    /// 요일 별 색상코드  함수
    private func color(for index: Int) -> Color {
        if index == 0 {
            return .red
        } else if index == weekdaySymbols.count - 1 {
            return .blue
        } else {
            return .primary
        }
    }
    
    /// 월 바꾸기 함수
    func changeMonth(by value: Int) {
        self.month = Calendar.current.date(byAdding: .month, value: value, to: month) ?? month
    }
    
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 인자로 받은  달의 첫 날이 속한 요일을 0부터 시작하는 인덱스로 변환
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 이전 달 Date 객체 반환
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    /// 특정 해당 날짜
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: month),
                month: calendar.component(.month, from: month),
                day: 1
            )
        ) else {
            return Date()
        }
        
        var dateComponents = DateComponents()
        dateComponents.day = index
        
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }
    
}
