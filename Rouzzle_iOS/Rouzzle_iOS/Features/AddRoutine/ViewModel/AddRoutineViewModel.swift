//
//  AddRoutineViewModel.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import Foundation
import Combine
import Factory
import SwiftData

@MainActor
@Observable
final class AddRoutineViewModel {
    private let swiftDataService: SwiftDataService
    init(context: ModelContext) {
        self.context = context
        swiftDataService = SwiftDataService(context: context)
    }
    // MARK: - Types
    enum Step: Double {
        case info = 0.5
        case task = 1.0
    }
        
    // MARK: - RoutineItem 업데이트 관련 프로퍼티
    var title: String = ""
    var emoji: String? = "🧩"
    var repeatCount: Int?
    var interval: Int?
    var selectedDateWithTime: [Day: Date] = [:]
    var alarmIDs: [Int: String]? {
        guard isNotificationEnabled else { return nil }
        return generateAlarmIDs(for: selectedDateWithTime)
    }
    var recommendTodoTask: [RecommendTodoTask] = []
    var routineTask: [RoutineTask] = []
    var isCompleted: Bool = false
    var context: ModelContext
    // MARK: - View 전용 프로퍼티
    var step: Step = .info
    var disabled: Bool {
        selectedDateWithTime.isEmpty || title.isEmpty
    }
    
    var isNotificationEnabled: Bool = false {
        didSet {
            if isNotificationEnabled {
                interval = interval ?? 1 // 기본값: 1분
                repeatCount = repeatCount ?? 1 // 기본값: 1번
            } else {
                interval = nil
                repeatCount = nil
            }
        }
    }
    
    var isDaily: Bool {
        get {
            selectedDateWithTime.count > 6 ? true : false
        }
    }
    
    var firstDayTime: String? {
        selectedDateWithTime
            .sorted(by: {$0.key.rawValue < $1.key.rawValue })
            .first
            .map { $0.value.formatted(.dateTime.hour().minute()) }
    }
    
    
    private func generateAlarmIDs(for dates: [Day: Date]) -> [Int: String] {
        var generatedIDs: [Int: String] = [:]
        for (day, _) in dates {
            generatedIDs[day.rawValue] = UUID().uuidString
        }
        return generatedIDs
    }
    
    func toggleDaily() {
        if selectedDateWithTime.isEmpty {
            let currentDate = Date()
            for day in Day.allCases {
                selectedDateWithTime[day] = currentDate
            }
        } else {
            selectedDateWithTime.removeAll()
        }
    }
    // 특정 요일이 선택되어 있는지 확인하는 함수
    func isSelected(_ day: Day) -> Bool {
        return selectedDateWithTime[day] != nil
    }
    // 개별 요일 토글
    func toggleDay(_ day: Day) {
        if isSelected(day) {
            selectedDateWithTime.removeValue(forKey: day)
        } else {
            selectedDateWithTime[day] = Date()
        }
    }
    
    func checkIfTimesAreDifferent() -> Bool {
        let uniqueTimes = Set(selectedDateWithTime.values.map {
            Calendar.current.dateComponents([.hour, .minute], from: $0)
        })
        return uniqueTimes.count > 1
    }
    
    func getRecommendTask() {
        guard let time = selectedDateWithTime.first?.value else {
            return
        }
        let timeSet = time.getTimeCategory()
        let routineTitles = routineTask.map { $0.title }
        recommendTodoTask = RecommendTaskData.getRecommendedTasks(for: timeSet, excluding: routineTitles)
    }
    
    /// 루틴 저장 메서드
    func saveRoutine() throws {
        guard !title.isEmpty else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        var dayStartTime: [Int: String] = [:]
        for (day, date) in selectedDateWithTime {
            dayStartTime[day.rawValue] = formatter.string(from: date)
        }
        
        let alarms = isNotificationEnabled ? generateAlarmIDs(for: selectedDateWithTime) : nil
        
        // 새로운 루틴 생성
        let newRoutine = RoutineItem(
            title: title,
            emoji: emoji ?? "🧩",
            dayStartTime: dayStartTime,
            repeatCount: repeatCount,
            interval: interval,
            alarmIDs: alarms
        )
        for task in routineTask.map({ $0.toTaskList() }) {
             swiftDataService.addTask(to: newRoutine, task: task)
        }
        // SwiftDataService를 이용해 루틴 추가
        try swiftDataService.addRoutine(newRoutine)
    }
    
}
