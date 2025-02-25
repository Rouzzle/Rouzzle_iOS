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
//    let modelContainer: ModelContainer
//    
//    init() {
//        do {
//            modelContainer = try ModelContainer(for: RoutineItem.self, TaskList.self)
//        } catch {
//            fatalError("❌ Could not initialize ModelContainer: \(error.localizedDescription)")
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [RoutineItem.self, TaskList.self])
        }
    }
}

