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
    
    /// 루틴 저장 메서드
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
        // SwiftDataService를 이용해 루틴 추가
        try swiftDataService.addRoutine(newRoutine)
        
        // ✅ 저장 후 알림이 활성화되어 있으면 예약
        if isNotificationEnabled {
            if isOneAlarm {
                scheduleSingleNotification(for: newRoutine)
            } else {
                scheduleRoutineNotifications(for: newRoutine)
            }
        }
    }
    
    // 요일을 한글 형식으로 변환하는 함수
    private func getKoreanWeekday(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return String(formatter.string(from: date).prefix(1))
    }
    
    // 시간을 "HH:mm" 형식으로 변환하는 함수
    private func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // MARK: 단일 알림 예약 함수
    private func scheduleSingleNotification(for routine: RoutineItem) {
        var scheduledDetails: [String] = []
                
        for (day, date) in selectedDateWithTime {
            let nextDate = NotificationManager.shared.nextTriggerDate(for: day.rawValue, hour: Calendar.current.component(.hour, from: date), minute: Calendar.current.component(.minute, from: date))
            
            let weekday = getKoreanWeekday(from: nextDate)
            let time = formatTime(from: nextDate)
            
            let notificationID = "routine_\(routine.id.uuidString)_weekday\(day.rawValue)"
            NotificationManager.shared.scheduleNotification(
                id: notificationID,
                routineTitle: title,
                date: nextDate,
                repeats: false
            )
            
            scheduledDetails.append("\(weekday)(\(time))")
        }
        
        print("🔔 단일 알림 예약 완료: \(scheduledDetails.joined(separator: ", "))")
    }
    
    // MARK: 반복 알림 예약 함수
    private func scheduleRoutineNotifications(for routine: RoutineItem) {
        var scheduledDetails: [String] = []
                
        for (day, date) in selectedDateWithTime {
            let nextDate = NotificationManager.shared.nextTriggerDate(for: day.rawValue, hour: Calendar.current.component(.hour, from: date), minute: Calendar.current.component(.minute, from: date))
            
            let weekday = getKoreanWeekday(from: nextDate)
            let time = formatTime(from: nextDate)
            
            scheduledDetails.append("\(weekday)(\(time))")
        }
        
        NotificationManager.shared.scheduleRoutineNotification(
            routineID: routine.id.uuidString,
            routineTitle: title,
            schedule: selectedDateWithTime.reduce(into: [Int: Date]()) { result, item in
                result[item.key.rawValue] = item.value
            },
            repetitionCount: repeatCount ?? 1,
            intervalMinutes: interval ?? 1
        )
        
        print("🔔 반복 알림 예약 완료: \(scheduledDetails.joined(separator: ", ")), 반복횟수: \(repeatCount ?? 1)회, 간격: \(interval ?? 1)분")
    }

    func requestNotificationPermissionIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("현재 알림 권한 상태: \(settings.authorizationStatus.rawValue)")
        }
    }
}
