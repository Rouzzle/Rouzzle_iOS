//
//  AddRoutineViewModel.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import Foundation
import Factory
import SwiftData

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
        
//        // 알림on -> notificationManager 통해 알림 예약
//        if isNotificationEnabled {
//            if isOneAlarm {
//                // 단일 알람 모드
//                for (day, date) in selectedDateWithTime {
//                    let weekday = day.rawValue
//                    let calendar = Calendar.current
//                    let comps = calendar.dateComponents([.hour, .minute], from: date)
//                    let hour = comps.hour ?? 0
//                    let minute = comps.minute ?? 0
//                    // 지정된 요일, 시, 분에 대해 다음 발생 시점을 계산
//                    let nextDate = NotificationManager.shared.nextTriggerDate(for: weekday, hour: hour, minute: minute)
//                    let notificationID = "routine_\(newRoutine.id.uuidString)_weekday\(weekday)"
//                    NotificationManager.shared.scheduleNotification(
//                        id: notificationID,
//                        title: title,
//                        body: "\(title) 루틴 알림",
//                        date: nextDate,
//                        repeats: false
//                    )
//                }
//            } else {
//                // 반복 알림 모드: 각 요일별로 repeatCount와 interval을 반영하여 예약
//                var schedule: [Int: Date] = [:]
//                for (day, date) in selectedDateWithTime {
//                    schedule[day.rawValue] = date
//                }
//                
//                //새로운 루틴의 고유 id 사용
//                NotificationManager.shared.scheduleRoutineNotification(
//                    routineID: newRoutine.id.uuidString,
//                    title: title,
//                    body: "\(title)루틴 알림",
//                    schedule: schedule,
//                    repetitionCount: repeatCount ?? 1,
//                    intervalMinutes: interval ?? 1
//                )
//            }
//            
//            
//        }
    }
    
    // ✅ 단일 알림 예약 함수
    private func scheduleSingleNotification(for routine: RoutineItem) {
        var scheduledDays: [String] = []
        var scheduledTimes: [String] = []
        
        for (day, date) in selectedDateWithTime {
            let weekday = day.rawValue
            let calendar = Calendar.current
            let comps = calendar.dateComponents([.hour, .minute], from: date)
            let hour = comps.hour ?? 0
            let minute = comps.minute ?? 0

            // ✅ 지정된 요일, 시, 분에 대해 다음 발생 시점을 계산
            let nextDate = NotificationManager.shared.nextTriggerDate(for: weekday, hour: hour, minute: minute)

            let notificationID = "routine_\(routine.id.uuidString)_weekday\(weekday)"
            NotificationManager.shared.scheduleNotification(
                id: notificationID,
                title: title,
                body: "\(title) 루틴 알림",
                date: nextDate,
                repeats: false
            )
            scheduledDays.append("요일\(weekday)")
            scheduledTimes.append(String(format: "%02d:%02d", hour, minute))
        }
        print("🔔 단일 알림 예약 완료: \(scheduledDays.joined(separator: ", "))")
    }
    
    // ✅ 반복 알림 예약 함수
    private func scheduleRoutineNotifications(for routine: RoutineItem) {
        let schedule: [Int: Date] = selectedDateWithTime.reduce(into: [:]) { result, item in
            result[item.key.rawValue] = item.value
        }

        NotificationManager.shared.scheduleRoutineNotification(
            routineID: routine.id.uuidString,
            title: title,
            body: "\(title) 루틴 알림",
            schedule: schedule,
            repetitionCount: repeatCount ?? 1,
            intervalMinutes: interval ?? 1
        )

        let scheduledDays = schedule.keys.map { "\($0)" }.joined(separator: ", ")
        let scheduledTimes = schedule.values.map {
                let comps = Calendar.current.dateComponents([.hour, .minute], from: $0)
                return String(format: "%02d:%02d", comps.hour ?? 0, comps.minute ?? 0)
            }.joined(separator: ", ")
        print("🔔 반복 알림 예약 완료: 요일(\(scheduledDays)), 시간(\(scheduledTimes)), 반복횟수: \(repeatCount ?? 1)회, 간격: \(interval ?? 1)분") // 요일마다 시간 다르게 하면 다 콘솔에서 확인하고 아니면 한 번만 출력하기로 바꿔야함
    }

}
