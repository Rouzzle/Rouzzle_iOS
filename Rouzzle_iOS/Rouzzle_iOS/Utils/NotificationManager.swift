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
    
    // ✅ 알림 권한 요청
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
    
    // ✅ 단일 알림 생성(1회만)
    func scheduleNotification(id: String, routineTitle: String, date: Date, repeats: Bool = false) {
        
        let content = UNMutableNotificationContent()
        content.title = "\(routineTitle)"
        content.body = "지금 바로 시작해볼까요?"
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: repeats)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 예약 오류: \(error.localizedDescription)")
            }
        }
    }
    
    // 반복 알림 생성(반복 간격, 횟수)
    /// - Parameters:
    ///   - routineID: 루틴 고유 식별자
    ///   - title: 알림 제목 (예: 루틴 이름)
    ///   - body: 알림 내용
    ///   - daysOfWeek: 알림을 울릴 요일 배열 (iOS에서는 일요일=1, 월요일=2, ...)
    ///   - startTime: 알림 시작 시간 (DateComponents의 hour, minute 사용)
    ///   - repetitionCount: 추가 알림 횟수 (총 알림 횟수는 repetitionCount + 1)
    ///   - intervalMinutes: 알림 간격 (분 단위)
    func scheduleRoutineNotification(routineID: String, routineTitle: String, schedule: [Int: Date], repetitionCount: Int, intervalMinutes: Int) {
        
        let calendar = Calendar.current
        
        for (weekday, startDate) in schedule {
            // startDate로부터 시, 분 추출
            let baseComponents = calendar.dateComponents([.weekday, .hour, .minute], from: startDate)
            
            // 선택한 요일마다 (repetitionCount + 1)회의 알림 예약
            for index in 0...repetitionCount {
                var triggerComponents = DateComponents()
                triggerComponents.weekday = weekday
                
                if let baseHour = baseComponents.hour, let baseMinute = baseComponents.minute {
                    // 임의의 날짜 기준으로 index에 따른 간격 추가
                    let baseDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1, hour: baseHour, minute: baseMinute))!
                    // index에 따른 간격 추가
                    let newDate = calendar.date(byAdding: .minute, value: index * intervalMinutes, to: baseDate)!
                    let newComponents = calendar.dateComponents([.hour, .minute], from: newDate)
                    triggerComponents.hour = newComponents.hour
                    triggerComponents.minute = newComponents.minute
                }
                
                let content = UNMutableNotificationContent()
                content.title = "\(routineTitle)"
                content.sound = .default
                content.userInfo = ["routineID": routineID]
                
                // 메시지 내용 설정
                if index == 0 {
                    content.body = "지금 바로 시작해볼까요?"
                } else {
                    let elapsedTime = index * intervalMinutes
                    content.body = "\(elapsedTime)분이 지났어요! 지금 시작해봐요"
                }
                
                // 매주 해당 요일/시간에 반복하도록 trigger
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
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
    
    // 헬퍼: 지정된 요일과 시각에 대해 다음 발생 시점을 계산
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
    
    // 특정 알림 삭제
    func removeSpecificNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("특정 알림 삭제: \(id)")
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
        print("포그라운드 알림 표시: \(notification.request.identifier)")

        completionHandler([.banner, .sound, .list])
    }
}


