//
//  NotificationManager.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 3/13/25.
//

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
    
    // ✅ 알림 생성 (단일 & 반복 통합)
    func scheduleNotification(id: String, title: String, body: String, date: Date, repeats: Bool = false) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: repeats)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 예약 오류: \(error.localizedDescription)")
            }
        }
    }
    
    // ✅ 특정 알림 삭제
    func removeSpecificNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("특정 알림 삭제: \(id)")
    }
    
    // ✅ 모든 알림 삭제
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("모든 알림 삭제")
    }
    
    // 포그라운드에서도 알림 표시
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
