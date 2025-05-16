//
//  TimerState.swift
//  Rouzzle_iOS
//
//  Created by Hyojeong on 3/3/25.
//

import SwiftUI
import Factory

@Observable
final class RoutineTimerViewModel {
    @ObservationIgnored
    @Injected(\.swiftDataService) private var swiftDataService: SwiftDataServiceProtocol
    
    private var timer: Timer?
    var timerState: TimerState = .running
    var viewTasks: [TaskList] = []
    var currentTaskIndex: Int = 0
    var timeRemaining: Int = 0
    var routineItem: RoutineItem
    var isResuming = false // 일시정지 후 재개 상태를 추적
    var routineTakeTime: (Date?, Date?) = (nil, nil) // 루틴 (시작, 종료) 시간
    var startTime: Date?
    private var endTime: Date?
    
    var routineCompleted: Bool = false
    
    var currentRoutineHistory: RoutineHistory? = nil // 현재 루틴 수행 기록
    
    var inProgressTask: TaskList? {
        guard !viewTasks.isEmpty else { return nil }
        if currentTaskIndex < viewTasks.count,
           !viewTasks[currentTaskIndex].isCompleted {
            return viewTasks[currentTaskIndex]
        }
        return viewTasks.first { !$0.isCompleted }
    }
    
    var isRoutineCompleted: Bool {
        !viewTasks.isEmpty && viewTasks.allSatisfy { $0.isCompleted }
    }
    
    private var pendingTasks: [TaskList] {
        viewTasks.filter { !$0.isCompleted }
    }
    
    // 현재 할일 뒤에 남은 할일
    var nextPendingTask: TaskList? {
        let pendings = pendingTasks
        guard pendings.count > 1,
              let current = inProgressTask,
              let idx = pendings.firstIndex(where: { $0.id == current.id }),
              idx + 1 < pendings.count
        else {
            return nil
        }
        return pendings[idx + 1]
    }
    
    // MARK: - CompleteView Properties
    // 루틴 이름(이모지 + 이름)
    var routineTitle: String {
        return "\(routineItem.emoji)  \(routineItem.title)"
    }
    
    // 루틴 시작/완료 시간
    var routineTimeRange: String {
        guard let start = routineTakeTime.0,
              let end = routineTakeTime.1
        else { return "시간 정보 없음" }
        return "\(start.toTimeString()) ~ \(end.toTimeString())"
    }
    
    // 누적일
    var totalDays: Int {
        return routineItem.totalDaysCount()
    }
    
    // 연속일
    var longestDays: Int {
        return routineItem.longestStreak()
    }
    
    // 완료된 할일 리스트
    var completedTasks: [TaskList] {
        return routineItem.taskList.filter { task in
            // TaskList가 연결된 TaskHistory 중 하나라도 완료되었으면 완료로 간주
            task.taskHistories.contains(where: { $0.isCompleted })
        }
    }
    
    init(routine: RoutineItem) {
        self.viewTasks = routine.taskList
        self.routineItem = routine
    }
    
    // MARK: - 타이머 시작 함수
    func startTimer() {
        let today = Date()
        // 1. 오늘 재개 가능한 history가 있으면 로드
        if currentRoutineHistory == nil,
           let unfinished = routineItem.history.first(
            where: { Calendar.current.isDate($0.date, inSameDayAs: today) && !$0.isCompleted }
           ) {
            currentRoutineHistory = unfinished
        }
        
        // 2. 새 세션 만들기
        if currentRoutineHistory == nil {
            let history = RoutineHistory(date: Date(), routine: routineItem)
            currentRoutineHistory = history
            try? swiftDataService.addRoutineHistory(history)
        }
        
        syncTasksFromHistory()
        currentTaskIndex = viewTasks.firstIndex(where: { !$0.isCompleted }) ?? 0
        
        // 타이머 설정
        if routineTakeTime.0 == nil {
            routineTakeTime.0 = today
        }
        startTime = today
        let task = viewTasks[currentTaskIndex]
        if !isResuming { timeRemaining = task.timer }
        isResuming = false
        timerState = .running
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining < 0 { self.timerState = .overtime }
        }
    }
    
    // MARK: - 루틴 완료 함수
    func endRoutine() {
        timer?.invalidate()
        timer = nil
        routineTakeTime.1 = Date() // 루틴 종료 시간 설정
        
        if let history = currentRoutineHistory {
            history.date = routineTakeTime.1!
            try? swiftDataService.updateRoutineHistory(history)
        }
        
        if isRoutineCompleted {
            routineCompleted = true
        }
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
    
    // MARK: - 완료 체크 및 다음 할일로 이동 함수
    func markTaskAsCompleted() {
        guard let history = currentRoutineHistory,
              let current = inProgressTask,
              let start = startTime
        else { return }
        
        // 1. 현재 할일 완료 처리
        let now = Date()
        current.elapsedTime = Int(now.timeIntervalSince(start))
        let taskHistory = TaskHistory(
            isCompleted: true,
            task: current,
            routineHistory: history
        )
        try? swiftDataService.addTaskHistory(taskHistory)
        history.taskHistories.append(taskHistory)
        current.taskHistories.append(taskHistory)
        current.isCompleted = true
        try? swiftDataService.updateRoutineHistory(history)
        
        // 2. 다음 할 일 찾기
        if viewTasks.allSatisfy({ $0.isCompleted }) {
            endRoutine()
        } else {
            let pendings = viewTasks.filter { !$0.isCompleted }
            let next = pendings.first!
            currentTaskIndex = viewTasks.firstIndex(where: { $0.id == next.id })!
            isResuming = false
            startTime = nil
            timerState = .running
            startTimer()
        }
    }
    
    // MARK: - 할일 스킵(inProgress -> pending 변경)
    func skipTask() {
        guard !isRoutineCompleted else {
            timer?.invalidate()
            return
        }
        
        timer?.invalidate()
        if let next = nextPendingTask,
           let nextIndex = viewTasks.firstIndex(where: { $0.id == next.id }) {
            currentTaskIndex = nextIndex
            isResuming = false
            startTimer()
        } else {
            endRoutine()
        }
    }
    
    // MARK: - 초기화 관련 함수
    /// 할일 인덱스 초기화
    private func initializeCurrentTaskIndex() {
        guard let history = currentRoutineHistory else {
            // 아직 오늘 세션 히스토리가 없으면 첫 번째로
            currentTaskIndex = 0
            return
        }
        // 이번 세션에 완료된 task만 제외
        if let idx = viewTasks.firstIndex(where: { task in
            !history.taskHistories.contains { $0.task?.id == task.id && $0.isCompleted }
        }) {
            currentTaskIndex = idx
        } else {
            // 이번 세션에서는 다 끝냈다 → 루틴 종료
            endRoutine()
        }
    }
    
    /// 할일 완료되면 초기화
    func resetTask() {
        guard let history = currentRoutineHistory, isRoutineCompleted else { return }
        
        for task in routineItem.taskList {
            task.isCompleted = false
            task.elapsedTime = nil
        }
        try? swiftDataService.updateRoutineHistory(history)
        currentRoutineHistory = nil
    }
    
    /// history 에 기록된 완료 상태를 viewTasks 에 동기화
    private func syncTasksFromHistory() {
        guard let history = currentRoutineHistory else { return }
        for hist in history.taskHistories where hist.isCompleted {
            if let task = viewTasks.first(where: { $0.id == hist.task?.id }) {
                task.isCompleted = true
            }
        }
    }
}
