//
//  RoutineItem+Extension.swift
//  Rouzzle_iOS
//
//  Created by 김동경 on 4/2/25.
//

import SwiftUI

extension RoutineItem {
    /// history 배열에서 startOfDay로 변환한 후, 정렬된 유니크 날짜 배열을 반환합니다.
    private func uniqueSortedDates() -> [Date] {
        let calendar = Calendar.current
        // RoutineItem 데이터가 하루에 한 번만 기록된다는 가정 하
        let uniqueDates = Set(history.filter { $0.isCompleted }.map { calendar.startOfDay(for: $0.date) })
        return uniqueDates.sorted()
    }
    
    /// 총 누적일을 계산합니다.
    /// - Returns: 루틴을 수행한 총  날짜 수
    func totalDaysCount() -> Int {
        return uniqueSortedDates().count
    }
    
    /// 전체 기록 중 최대 연속 일수를 계산합니다.
    /// - Returns: 가장 오랫동안 연속적으로 루틴을 수행한 일수
    func longestStreak() -> Int {
        let calendar = Calendar.current
        let sortedDates = uniqueSortedDates()
        var longestStreak = 0
        var currentStreak = 0
        var previousDate: Date?
        
        for date in sortedDates {
            if let previous = previousDate,
               calendar.isDate(date, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: previous)!) {
                // 이전 날짜의 다음 날이라면 연속
                currentStreak += 1
            } else {
                // 연속이 끊겼다면 새롭게 시작
                currentStreak = 1
            }
            longestStreak = max(longestStreak, currentStreak)
            previousDate = date
        }
        
        return longestStreak
    }
    
    /// 오늘 기준으로 현재 연속 일수를 계산합니다.
    /// - Returns: 오늘부터 거슬러 올라갔을 때 연속으로 기록된 일수
    func currentStreak() -> Int {
        let calendar = Calendar.current
        // 날짜를 하루 단위로 비교하기 위해 today의 startOfDay 사용
        let today = calendar.startOfDay(for: Date())
        // history의 날짜들을 Set으로 만들어 빠른 조회를 가능하게 함
        let uniqueDates = Set(history.map { calendar.startOfDay(for: $0.date) })
        
        var streak = 0
        var checkDate = today
        
        // 오늘부터 하루씩 이전 날짜가 존재하는지 확인
        while uniqueDates.contains(checkDate) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else {
                break
            }
            checkDate = previousDay
        }
        return streak
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
