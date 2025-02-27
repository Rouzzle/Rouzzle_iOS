//
//  Rouzzle_iOSApp.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/4/25.
//

import SwiftUI
import SwiftData

@main
struct Rouzzle_iOSApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: RoutineItem.self, TaskList.self)
        } catch {
            fatalError("❌ ModelContainer 초기화 실패: \(error.localizedDescription)")
        }
        // 앱 시작 시 한 번만 SwiftDataServiceSingleton을 구성합니다.
        SwiftDataService.configure(with: modelContainer.mainContext)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer) // ContentView에 동일한 ModelContainer 전달
        }
    }
}

