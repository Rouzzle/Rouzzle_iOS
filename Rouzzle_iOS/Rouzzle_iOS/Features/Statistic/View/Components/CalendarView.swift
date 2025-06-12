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
    
    var body: some View {
        VStack {
            weekdayHeaderView
            calendarGridView
            Spacer()
        }
    }
}

// MARK: - Calendar Components
private extension CalendarView {
    var weekdayHeaderView: some View {
        HStack {
            ForEach(Calendar.current.shortWeekdaySymbols.indices, id: \.self) { index in
                Text(Calendar.current.shortWeekdaySymbols[index].uppercased())
                    .foregroundStyle(weekdayColor(for: index))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }
    
    var calendarGridView: some View {
        let calendar = Calendar.current
        let daysInMonth = numberOfDays(in: month)
        let firstWeekday = firstWeekdayOfMonth(in: month) - 1
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                CalendarDayView(
                    index: index,
                    month: month,
                    daysInMonth: daysInMonth,
                    selectedRoutine: selectedRoutine
                )
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Helper Functions
private extension CalendarView {
    func weekdayColor(for index: Int) -> Color {
        switch index {
        case 0: return .red
        case 6: return .blue
        default: return .primary
        }
    }
    
    func numberOfDays(in date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
}