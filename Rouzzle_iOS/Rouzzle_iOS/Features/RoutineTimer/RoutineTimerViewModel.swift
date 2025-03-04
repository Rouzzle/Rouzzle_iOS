//
//  TimerState.swift
//  Rouzzle_iOS
//
//  Created by Hyojeong on 3/3/25.
//

import SwiftUI
import Factory
import SwiftData

@Observable
final class RoutineTimerViewModel {
    @ObservationIgnored
    @Injected(\.swiftDataService) private var swiftDataService: SwiftDataServiceProtocol
    
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
    
    // MARK: - ViewModel
    var timerState: TimerState = .running
    var viewTasks: [TaskList] = []
    var isRoutineCompleted = false // 모든 작업 완료 여부 체크
    var currentTaskIndex: Int = 0
    
    var inProgressTask: TaskList? {
        if viewTasks.isEmpty || isRoutineCompleted {
            return nil // 진행 중인 작업이 없음
        }
        return viewTasks[currentTaskIndex] // 진행 중인 작업 가져옴
    }
    
    init(routine: RoutineItem) {
        self.viewTasks = routine.taskList
    }
}
