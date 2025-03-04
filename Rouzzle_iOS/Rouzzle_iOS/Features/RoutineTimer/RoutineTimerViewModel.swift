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
    private var timer: Timer?
    var timerState: TimerState = .running
    var viewTasks: [TaskList] = []
    var isRoutineCompleted = false // 모든 작업 완료 여부 체크
    var currentTaskIndex: Int = 0
    var timeRemaining: Int = 0
    private var isResuming = false // 일시정지 후 재개 상태를 추적
    var routineTakeTime: (Date?, Date?) // 루틴 시작 시간 저장
    private var startTime: Date?
    private var endTime: Date?
    
    var inProgressTask: TaskList? {
        if viewTasks.isEmpty || isRoutineCompleted {
            return nil // 진행 중인 작업이 없음
        }
        return viewTasks[currentTaskIndex] // 진행 중인 작업 가져옴
    }
    
    init(routine: RoutineItem) {
        self.viewTasks = routine.taskList
    }
    
    // MARK: - 타이머 시작 함수
    func startTimer() {
        guard currentTaskIndex < viewTasks.count else {
            isRoutineCompleted = true
            return
        }
        
        if routineTakeTime.0 == nil {
            routineTakeTime.0 = Date() // 루틴 시작 시간 저장
        }
        
        startTime = Date()
        
        let currentTask = viewTasks[currentTaskIndex]
        
        if !isResuming { // 새로 시작하는 경우
            self.timeRemaining = currentTask.timer
        }
        isResuming = false
        
        guard timerState == .running || timerState == .overtime else { return } // paused에서 동작 X
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining < 0 {
                self.timerState = .overtime
            }
            if self.isRoutineCompleted {
                endRoutine()
            }
        }
    }
    
    // MARK: - 루틴 완료 함수
    func endRoutine() {
        timer?.invalidate()
        timer = nil
        routineTakeTime.1 = Date() // 루틴 종료 시간 설정
        isRoutineCompleted = true
    }
    
    // MARK: - 타이머 토글 함수
    func toggleTimer() {
        if timerState == .running || timerState == .overtime {
            timerState = .paused
            timer?.invalidate()
        } else {
            timerState = timeRemaining >= 0 ? .running : .overtime
            isResuming = true
            startTimer()
        }
    }
    

}
