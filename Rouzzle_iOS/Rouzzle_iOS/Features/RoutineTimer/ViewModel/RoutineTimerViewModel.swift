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
       
    private var timer: Timer?
    var timerState: TimerState = .running
    var viewTasks: [TaskList] = []
    var currentTaskIndex: Int = 0
    var timeRemaining: Int = 0
    var routineItem: RoutineItem
    private var isResuming = false // 일시정지 후 재개 상태를 추적
    var routineTakeTime: (Date?, Date?) // 루틴 (시작, 종료) 시간
    private var startTime: Date?
    private var endTime: Date?
    
    var currentRoutineHistory: RoutineHistory // 현재 루틴 수행 기록
    
    var inProgressTask: TaskList? {
        if viewTasks.isEmpty || currentTaskIndex >= viewTasks.count {
            return nil // 진행 중인 작업이 없음
        }
        return viewTasks[currentTaskIndex] // 진행 중인 작업 가져옴
    }
    
    // TaskHistory에서 완료 여부 확인
    var isRoutineCompleted: Bool {
        return viewTasks.allSatisfy { task in
            task.taskHistories.contains(where: { $0.isCompleted })
        }
    }
    
    var nextPendingTask: TaskList? {
        let totalTasks = viewTasks.count
        var nextIndex = currentTaskIndex
        var checkedTasks = 0

        while checkedTasks < totalTasks {
            nextIndex = (nextIndex + 1) % totalTasks
            checkedTasks += 1
            // 해당 작업에 완료된 TaskHistory가 없으면 미완료로 판단
            if !viewTasks[nextIndex].taskHistories.contains(where: { $0.isCompleted }) && nextIndex != currentTaskIndex {
                return viewTasks[nextIndex]
            }
        }
        return nil
    }
    
    init(routine: RoutineItem) {
        self.viewTasks = routine.taskList
        self.routineItem = routine
        self.currentRoutineHistory = RoutineHistory(date: Date(), routine: routine)
    }
    
    // MARK: - 타이머 시작 함수
    func startTimer() {
        guard currentTaskIndex < viewTasks.count else {
            endRoutine()
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
    func markTaskAsCompleted(_ context: ModelContext) {
        guard currentTaskIndex < viewTasks.count else {
            endRoutine()
            return
        }
        
        endTime = Date()
        let elapsedTime = Int(endTime?.timeIntervalSince(startTime ?? Date()) ?? 0) // 루틴 수행 시간
        let currentTask = viewTasks[currentTaskIndex]
        currentTask.elapsedTime = elapsedTime
        
        let taskHistory = TaskHistory(isCompleted: true, task: currentTask, routineHistory: currentRoutineHistory)
        currentTask.taskHistories.append(taskHistory)
        currentRoutineHistory.taskHistories.append(taskHistory)
        
        currentTask.isCompleted = true // UI 변경을 위해
            
        do {
            try context.save()
            startTime = nil
            endTime = nil
        } catch {
            print("할일 완료 실패")
        }
        
        timer?.invalidate()
        moveToNextIncompleteTask()
        
        if currentTaskIndex < viewTasks.count { // 다음 작업 남아있으면 타이머 재시작
            timerState = .running
            startTimer()
        } else {
            endRoutine()
        }
    }
    
    // MARK: - 할일 완료 시 다음 할일로 이동 함수
    func moveToNextIncompleteTask() {
        var foundIncompleteTask = false
        var checkedTasks = 0
        
        while checkedTasks < viewTasks.count {
            currentTaskIndex = (currentTaskIndex + 1) % viewTasks.count
            checkedTasks += 1
            if !viewTasks[currentTaskIndex].taskHistories.contains(where: { $0.isCompleted }) {
                foundIncompleteTask = true
                break
            }
        }
        
        if !foundIncompleteTask {
            endRoutine()
        }
    }
    
    // MARK: - 할일 스킵(inProgress -> pending 변경)
    func skipTask() {
        guard !isRoutineCompleted else {
            timer?.invalidate()
            return
        }
        
        timer?.invalidate()
        moveToNextIncompleteTask()
        
        if !isRoutineCompleted {
            timerState = .running
            isResuming = false
            startTimer()
        } else {
            endRoutine()
        }
    }
    
    // MARK: - 진행 중인 할일 인덱스 초기화
    func initializeCurrentTaskIndex() {
        if let index = viewTasks.firstIndex(where: { !$0.taskHistories.contains(where: { $0.isCompleted }) }) {
            currentTaskIndex = index
        } else {
            endRoutine()
        }
    }
    
    // MARK: - 모든 할일 완료되면 초기화
    func resetTask() {
        print("리셋 테스크")
    
        // 연결된 TaskHistory 기록 모두 삭제하고 elapsedTime 초기화
        if routineItem.taskList.filter({ !$0.taskHistories.contains(where: { $0.isCompleted }) }).isEmpty && !routineItem.taskList.isEmpty {
            for task in routineItem.taskList {
                task.taskHistories.removeAll()
                task.elapsedTime = nil
            }
        }
    }
}
