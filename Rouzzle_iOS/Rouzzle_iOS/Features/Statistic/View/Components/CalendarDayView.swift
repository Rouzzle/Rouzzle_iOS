//
//  CalendarDayView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI

struct CalendarDayView: View {
    let index: Int
    let month: Date
    let daysInMonth: Int
    let selectedRoutine: RoutineItem
    
    private let calendar = Calendar.current
    
    var body: some View {
        Group {
            if isCurrentMonthDay {
                currentMonthDayView
            } else {
                previousMonthDayView
            }
        }
    }
}

// MARK: - View Components
private extension CalendarDayView {
    var isCurrentMonthDay: Bool {
        index > -1 && index < daysInMonth
    }
    
    var currentMonthDayView: some View {
        let date = getDate(for: index)
        let day = calendar.component(.day, from: date)
        let history = getHistoryForDate(date)
        
        return ZStack {
            if let color = history?.rateColor {
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundColor(color)
            }
            Text("\(day)")
                .foregroundStyle(history != nil ? .white : .primary)
                .lineLimit(1)
                .padding(.vertical, 12)
        }
    }
    
    var previousMonthDayView: some View {
        Group {
            if let prevMonthDate = getPreviousMonthDate(for: index) {
                let day = calendar.component(.day, from: prevMonthDate)
                Text("\(day)")
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .padding(.vertical, 12)
            }
        }
    }
}

// MARK: - Helper Functions
private extension CalendarDayView {
    func getHistoryForDate(_ date: Date) -> RoutineHistory? {
        selectedRoutine.history.first { history in
            calendar.isDate(history.date, inSameDayAs: date)
        }
    }
    
    func getPreviousMonthDate(for index: Int) -> Date? {
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        return calendar.date(
            byAdding: .day,
            value: index + lastDayOfMonthBefore,
            to: previousMonth()
        )
    }
    
    func numberOfDays(in date: Date) -> Int {
        calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func previousMonth() -> Date {
        let components = calendar.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = calendar.date(from: components)!
        return calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
    }
    
    func getDate(for index: Int) -> Date {
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
        
        return calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
    }
}