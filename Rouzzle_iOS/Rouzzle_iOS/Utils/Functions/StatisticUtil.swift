//
//  StatisticUtil.swift
//  Rouzzle_iOS
//
//  Created by 김동경 on 3/18/25.
//

import Foundation
import SwiftUICore

class StatisticUtil {
    static let shared = StatisticUtil()
    
    func nextScheduledDate(after date: Date, validWeekdays: Set<Int>, calendar: Calendar) -> Date? {
        var nextDate = calendar.date(byAdding: .day, value: 1, to: date)!
        for _ in 0..<7 {
            let weekday = calendar.component(.weekday, from: nextDate)
            if validWeekdays.contains(weekday) {
                return nextDate
            }
            nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
        }
        return nil
    }

    // validWeekdays를 고려하여, 완료된 RoutineHistory들의 날짜에서 최대 연속 streak를 계산하는 함수
    func calculateMaxStreak(for histories: [RoutineHistory], validWeekdays: Set<Int>) -> Int {
        let calendar = Calendar.current
        // 완료된 날짜 중, 해당 요일이 validWeekdays에 포함된 날짜만 필터링
        let completedDates = histories
            .filter { $0.isCompleted && validWeekdays.contains(calendar.component(.weekday, from: $0.date)) }
            .map { $0.date }
            .sorted()
        
        guard !completedDates.isEmpty else { return 0 }
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 0..<completedDates.count - 1 {
            let currentDate = completedDates[i]
            // currentDate 이후의 다음 스케줄 날짜 계산
            if let expectedNextDate = nextScheduledDate(after: currentDate, validWeekdays: validWeekdays, calendar: calendar) {
                // 다음 완료 날짜가 예상 스케줄 날짜와 같으면 연속 streak 증가
                if calendar.isDate(completedDates[i + 1], inSameDayAs: expectedNextDate) {
                    currentStreak += 1
                } else {
                    maxStreak = max(maxStreak, currentStreak)
                    currentStreak = 1
                }
            }
        }
        
        maxStreak = max(maxStreak, currentStreak)
        return maxStreak
    }
    
    func computeStreaks(from allHistories: [RoutineHistory]) -> [RoutineItem: Int] {
        let groupedTuples = Dictionary(grouping: allHistories.compactMap { (history: RoutineHistory) -> (RoutineItem, RoutineHistory)? in
            guard let routine = history.routine else { return nil }
            return (routine, history)
        }, by: { $0.0 })

        let grouped: [RoutineItem: [RoutineHistory]] = groupedTuples.mapValues { tuples in
            tuples.map { $0.1 }
        }
        var streaks: [RoutineItem: Int] = [:]

        for (routine, histories) in grouped {
              // 루틴이 실행되는 요일을 dayStartTime의 키 값으로 지정 (예: [2,4,6])
              let validWeekdays = Set(routine.dayStartTime.keys)
              let streak = calculateMaxStreak(for: histories, validWeekdays: validWeekdays)
              streaks[routine] = streak
          }
        
        return streaks
    }
    
    
    func computeMonthlyStats(for routine: RoutineItem, month: Date, histories: [RoutineHistory]) -> RoutineStats {
        let calendar = Calendar.current
        
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let range = calendar.range(of: .day, in: .month, for: month)
        else {
            return RoutineStats(scheduledCount: 0, completedCount: 0)
        }
        //let lastDay = calendar.date(byAdding: .day, value: range.count - 1, to: firstDay)!
        
        let validWeekdays = Set(routine.dayStartTime.keys)
        
        var scheduledCount = 0
        var completedCount = 0
        
        for day in range {
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) else { continue }
            let weekday = calendar.component(.weekday, from: date)
            if validWeekdays.contains(weekday) {
                scheduledCount += 1
                // 해당 날짜에 routine에 해당하는 RoutineHistory가 있고 완료되었는지 확인
                let isCompletedOnDate = histories.contains { history in
                    if let historyRoutine = history.routine, historyRoutine.id == routine.id {
                        return calendar.isDate(history.date, inSameDayAs: date) && history.isCompleted
                    }
                    return false
                }
                if isCompletedOnDate {
                    completedCount += 1
                }
            }
        }
        
        return RoutineStats(scheduledCount: scheduledCount, completedCount: completedCount)
    }

    /// 전체 RoutineHistory 데이터를 받아, 루틴별로 그룹핑한 후 선택한 달에 대한 통계를 계산하는 함수
    func computeMonthlyStatsForGroupedHistories(from allHistories: [RoutineHistory], for month: Date) -> [RoutineItem: RoutineStats] {
        let calendar = Calendar.current
        // 전체 RoutineHistory를 (RoutineItem, RoutineHistory) 쌍으로 변환하여 그룹핑
        let groupedTuples = Dictionary(grouping: allHistories.compactMap { (history: RoutineHistory) -> (RoutineItem, RoutineHistory)? in
            guard let routine = history.routine else { return nil }
            return (routine, history)
        }, by: { $0.0 })
        
        // 각 루틴별로 RoutineHistory 배열로 변환
        let grouped: [RoutineItem: [RoutineHistory]] = groupedTuples.mapValues { tuples in
            tuples.map { $0.1 }
        }
        
        var statsDict: [RoutineItem: RoutineStats] = [:]
        
        for (routine, histories) in grouped {
            // 선택한 달에 해당하는 RoutineHistory만 필터링 (연, 월 비교)
            let monthlyHistories = histories.filter { history in
                let historyComponents = calendar.dateComponents([.year, .month], from: history.date)
                let selectedComponents = calendar.dateComponents([.year, .month], from: month)
                return historyComponents.year == selectedComponents.year && historyComponents.month == selectedComponents.month
            }
            
            let stats = computeMonthlyStats(for: routine, month: month, histories: monthlyHistories)
            statsDict[routine] = stats
        }
        
        return statsDict
    }
    
    func statisPercentageColor(percentage: Int) -> Color {
        return switch percentage {
        case 0..<29:
                .accent.opacity(0.3)
        case 30..<60:
                .accent.opacity(0.6)
        default:
             .accentColor
        }
    }
}


struct RoutineStats {
    let scheduledCount: Int    // 해당 달에 실행 예정인 횟수
    let completedCount: Int    // 해당 달에 실제 완료된 횟수
    var completionPercentage: Int {
        scheduledCount > 0 ? Int((Double(completedCount) / Double(scheduledCount)) * 100) : 0
    }
}
