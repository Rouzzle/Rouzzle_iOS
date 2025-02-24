//
//  ConvertString.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/24/25.
//

import Foundation

/// days 에 따라 매일, 평일, 주말로 바꿔주는 함수 
func convertDaysToString(days: [Int]) -> String {
    let dayNames = ["일", "월", "화", "수", "목", "금", "토"]
    
    let dayStrings = days.compactMap { dayIndex -> String? in
        guard dayIndex >= 1 && dayIndex <= 7 else { return nil }
        return dayNames[dayIndex - 1]
    }
    
    if days.contains(1) && days.contains(7) && days.count == 7 {
        return "매일"
    } else if Set([2, 3, 4, 5, 6]).isSubset(of: days) && !days.contains(1) && !days.contains(7) {
        return "평일"
    } else if Set([1, 7]).isSubset(of: days) && days.count == 2 {
        return "주말"
    } else {
        return dayStrings.joined(separator: " ")
    }
}
