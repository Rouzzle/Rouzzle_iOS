//
//  NotificationManager.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 3/13/25.
//
// 1. 루틴 생성 시, 알림 생성
// 2. 루틴 수정 시, 알림 수정
// 3. 루친 삭제 시, 알림 삭제
// 4. 루틴이 이미 실행 중 or 실행 완료 -> 울릴 예정이었던 알림 패스

import Foundation
import UserNotifications

// 노티 알람 매니저 (권한요청, 알림생성, 삭제)
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {}

    // MARK: - Helper Functions
        
    private func makeNotificationTitle(for routineTitle: String) -> String {
        return "\(routineTitle) 알림"
    }
    
    private func makeNotificationBody(for index: Int, intervalMinutes: Int) -> String {
        return index == 0 ? "지금 바로 시작해볼까요?" : "\(index * intervalMinutes)분이 지났어요! 지금 시작해봐요"
    }
    
    /// 요일, 기준 시각, index 및 간격을 기반으로 주간 반복 트리거 생성 (옵셔널 안전 처리)
    private func createWeeklyTrigger(weekday: Int, baseHour: Int, baseMinute: Int, index: Int, intervalMinutes: Int) -> UNCalendarNotificationTrigger? {
        let calendar = Calendar.current
        let dummyComponents = DateComponents(year: 2000, month: 1, day: 1, hour: baseHour, minute: baseMinute)
        guard let baseDate = calendar.date(from: dummyComponents),
              let newDate = calendar.date(byAdding: .minute, value: index * intervalMinutes, to: baseDate) else { return nil }
        
        let newTimeComponents = calendar.dateComponents([.hour, .minute], from: newDate)
        var triggerComponents = DateComponents()
        triggerComponents.weekday = weekday
        triggerComponents.hour = newTimeComponents.hour
        triggerComponents.minute = newTimeComponents.minute
        return UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
    }
    
    // MARK: Public Methods
    
    // 알림 권한 요청
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 권한 요청 오류: \(error.localizedDescription)")
                }
                completion(granted)
            }
        }
    }
    
    // 단일 알림 생성(1회만)
    func scheduleNotification(id: String, routineTitle: String, weekday: Int, hour: Int, minute: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = makeNotificationTitle(for: routineTitle)
        content.body = "지금 바로 시작해볼까요?"
        content.sound = .default
        
        var components = DateComponents()
        components.weekday = weekday  // 일:1 ~ 토:7 (주의!)
        components.hour = hour
        components.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 예약 오류: \(error.localizedDescription)")
            }
        }
    }
    
    // 반복 알림 생성
    func scheduleRoutineNotification(routineID: String, routineTitle: String, schedule: [Int: Date], repetitionCount: Int, intervalMinutes: Int) {
        
        let calendar = Calendar.current
        
        for (weekday, startDate) in schedule {
            // startDate로부터 시, 분 추출
            let baseComponents = calendar.dateComponents([.hour, .minute], from: startDate)
            guard let baseHour = baseComponents.hour, let baseMinute = baseComponents.minute else { continue }
            
            // 선택한 요일마다 (repetitionCount + 1)회의 알림 예약
            for index in 0...repetitionCount {
                guard let trigger = createWeeklyTrigger(weekday: weekday, baseHour: baseHour, baseMinute: baseMinute, index: index, intervalMinutes: intervalMinutes) else { continue }
                
                let content = UNMutableNotificationContent()
                content.title = makeNotificationTitle(for: routineTitle)
                content.body = makeNotificationBody(for: index, intervalMinutes: intervalMinutes)
                content.sound = .default
                content.userInfo = ["routineID": routineID]
                
                let notificationID = "routine_\(routineID)_weekday\(weekday)_index\(index)"
                let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("알림 등록 오류: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // 지정된 요일과 시각에 대해 다음 발생 시점을 계산
    func nextTriggerDate(for weekday: Int, hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        let now = Date()
        var components = DateComponents()
        components.weekday = weekday
        components.hour = hour
        components.minute = minute
        components.second = 0
        
        // now 이후의 다음 발생 시점 계산 (matchPolicy: .nextTime
        if let nextDate = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime) {
            return nextDate
        }
        return now
    }
    
    // 루틴 상태 체크 (알림 발생 직전에 호출)
    /// 오늘 해당 루틴이 진행 중이거나 이미 완료 -> true
    /// 실제 로직은 수정 필요
    func isRoutineActiveOrCompleted(for routineID: String, on date: Date) -> Bool {
        // TODO: 실제 루틴의 상태(진행 중/실행 완료) 체크 로직 구현
        return false
        
    }
    
    // 모든 알림 삭제
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("모든 알림 삭제")
    }
    
    // 포그라운드에서도 알림 표시
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("포그라운드 알림 표시: \(notification.request.identifier)")
        completionHandler([.banner, .sound, .list])
    }
    
    // 특정 알림 삭제
    func removeSpecificNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("특정 알림 삭제: \(id)")
    }
    
    // 루틴 실행 시 해당 알림 삭제(일시적)
    func cancelTodayAlarms(for routine: RoutineItem) {
        let routineID = routine.id.uuidString
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        let repetitionCount = routine.repeatCount ?? 0

        for index in 0...repetitionCount {
            let alarmID = "routine_\(routineID)_weekday\(weekday)_index\(index)"
            removeSpecificNotification(id: alarmID)
        }
    }

}


