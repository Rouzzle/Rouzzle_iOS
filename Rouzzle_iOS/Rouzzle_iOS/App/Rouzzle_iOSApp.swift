//
//  Rouzzle_iOSApp.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/4/25.
//

import SwiftUI
import SwiftData
import Factory
import UserNotifications

@main
struct Rouzzle_iOSApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
#if DEBUG
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil { // 프리뷰에서 사용될 모델 컨테이너 
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                modelContainer = try ModelContainer(for: RoutineItem.self, TaskList.self, configurations: config)
            } else {
                modelContainer = try ModelContainer(for: RoutineItem.self, TaskList.self)
            }
#else
            modelContainer = try ModelContainer(for: RoutineItem.self, TaskList.self)
#endif
        } catch {
            fatalError("❌ ModelContainer 초기화 실패: \(error.localizedDescription)")
        }
        Container.modelContainer = modelContainer  // Container의 전역 변수에 주입
        setupNotificationDelegate()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer) // ContentView에 동일한 ModelContainer 전달
                //.modelContainer(SampleData.shared.modelContainer)
        }
    }
    
    private func setupNotificationDelegate() {
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationManager.shared // ✅ 알림 delegate 설정
    }
}
