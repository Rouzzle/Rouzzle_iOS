//
//  TimerState.swift
//  Rouzzle_iOS
//
//  Created by Hyojeong on 3/25/25.
//

import SwiftUI

// MARK: - 타이머 관련 색상
enum TimerState {
    case running
    case paused
    case overtime
    
    var gradientColors: [Color] {
        switch self {
        case .overtime:
            return [.white, Color(.overtimeBackground)]
        case .running:
            return [.white, Color(.playBackground)]
        case .paused:
            return [.white, Color(.pauseBackground)]
        }
    }
    
    var puzzleTimerColor: Color {
        switch self {
        case .overtime:
            return Color(.overtimePuzzleTimer)
        case .running:
            return Color.themeColor
        case .paused:
            return Color(.pausePuzzleTimer)
        }
    }
    
    var timeTextColor: Color {
        switch self {
        case .overtime:
            return Color(.overtimePuzzleTimer)
        case .running:
            return .accent
        case .paused:
            return .white
        }
    }
}
