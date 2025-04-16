//
//  AddRoutineViewModel.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import Foundation
import Factory
import SwiftData
import UserNotifications
//import os.log

// MARK: Date Extension (시간 포매팅 및 한글 요일 계산)
extension Date {
    func formattedHourMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func koreanWeekday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return String(formatter.string(from: self).prefix(1))
    }
}

@MainActor
@Observable
final class AddRoutineViewModel {
    @ObservationIgnored
    @Injected(\.swiftDataService) private var swiftDataService: SwiftDataServiceProtocol

    // MARK: - Types
    enum Step: Double {
        case info = 0.5
        case task = 1.0
    }

    // MARK: - RoutineItem 업데이트 관련 프로퍼티
    var title: String = ""
    var emoji: String? = "🧩"
    var repeatCount: Int = 1
    var interval: Int = 1
    var selectedDateWithTime: [Day: Date] = [:]
    var alarmIDs: [Int: String]? {
        guard isNotificationEnabled else { return nil }
        return generateAlarmIDs(for: selectedDateWithTime)
    }
    var recommendTodoTask: [RecommendTodoTask] = []
    var routineTask: [RoutineTask] = []
    var isCompleted: Bool = false
    var isOneAlarm: Bool = false //추가: "1회만" 체크박스 선택 여부
    // MARK: - View 전용 프로퍼티
    var step: Step = .info
    var disabled: Bool {
        selectedDateWithTime.isEmpty || title.isEmpty
    }
    
    var isNotificationEnabled: Bool = false {
        didSet {
            if isNotificationEnabled {
                NotificationManager.shared.requestNotificationPermission { granted in
                    if !granted {
                        print("알림 권한 거부")
                        self.isNotificationEnabled = false
                    }
                }
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
            .first?
            .value
            .formattedHourMinute()
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
    
    // 요일 시간 한번에 수정했을 때 불리는 함수
    func selectedDayChangeDate(_ date: Date) {
        for day in selectedDateWithTime.keys {
            selectedDateWithTime[day] = date
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
    
    // MARK: 루틴 저장 및 알림 예약
    func saveRoutine() throws {
        guard !title.isEmpty else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        var dayStartTime: [Int: String] = [:]
        for (day, date) in selectedDateWithTime {
            dayStartTime[day.rawValue] = formatter.string(from: date)
        }
        
        let alarms = alarmIDs
        
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
            try swiftDataService.addTask(to: newRoutine, task: task)
        }
        
        try swiftDataService.addRoutine(newRoutine)
        
        // 저장 후 알림이 활성화되어 있으면 예약
        if isNotificationEnabled {
            if isOneAlarm {
                scheduleSingleNotification(for: newRoutine)
            } else {
                scheduleRoutineNotifications(for: newRoutine)
            }
        }
    }
    
    // MARK: - 알림 예약 헬퍼 메서드
    private func nextNotificationDate(for day: Day, date: Date) -> Date {
        return NotificationManager.shared.nextTriggerDate(
            for: day.rawValue,
            hour: Calendar.current.component(.hour, from: date),
            minute: Calendar.current.component(.minute, from: date)
        )
    }
    
    // MARK: 단일 알림 예약 함수
    private func scheduleSingleNotification(for routine: RoutineItem) {
        var scheduledDetails: [String] = []
                
        for (day, date) in selectedDateWithTime {
            let nextDate = nextNotificationDate(for: day, date: date)
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: nextDate)
            guard let hour = components.hour, let minute = components.minute else { continue }

            let weekday = day.rawValue // Int (1~7, 일~토)
            let notificationID = "routine_\(routine.id.uuidString)_weekday\(weekday)"
            
            NotificationManager.shared.scheduleNotification(
                id: notificationID,
                routineTitle: title,
                weekday: weekday,
                hour: hour,
                minute: minute
            )
            
            let weekdayName = nextDate.koreanWeekday()
            let timeString = date.formattedHourMinute()
            scheduledDetails.append("\(weekdayName) (\(timeString))")
        }
        print("🔔 단일 알림 예약 완료: \(scheduledDetails.joined(separator: ", "))")
    }
    
    // MARK: 반복 알림 예약 함수
    private func scheduleRoutineNotifications(for routine: RoutineItem) {
        var scheduledDetails: [String] = []
                
        for (day, date) in selectedDateWithTime {
            let nextDate = nextNotificationDate(for: day, date: date)
            let weekday = nextDate.koreanWeekday()
            let time = nextDate.formattedHourMinute()
            
            scheduledDetails.append("\(weekday)(\(time))")
        }
        let weekdaySchedule: [Int: Date] = selectedDateWithTime.reduce(into: [Int: Date]()) { result, item in
            result[item.key.rawValue] = item.value
        }
        
        NotificationManager.shared.scheduleRoutineNotification(
            routineID: routine.id.uuidString,
            routineTitle: title,
            schedule: weekdaySchedule,
            repetitionCount: repeatCount,
            intervalMinutes: interval
        )
        
        print("🔔 반복 알림 예약 완료: \(scheduledDetails.joined(separator: ", ")), 반복횟수: \(repeatCount)회, 간격: \(interval)분")
    }

    func requestNotificationPermissionIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("현재 알림 권한 상태: \(settings.authorizationStatus.rawValue)")
        }
    }
    
    // MARK: - Task 관련 메서드
    func addTask(from recommend: RecommendTodoTask, to routineItem: RoutineItem) {
        let task = recommend.toTaskList()
        try? swiftDataService.addTask(to: routineItem, task: task)
    }
}
