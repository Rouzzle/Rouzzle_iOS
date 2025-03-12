//
//  SampleData.swift
//  Rouzzle_iOS
//
//  Created by 김동경 on 3/11/25.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    //모델 컨테이너의 메인 컨텍스트에 접근할 수 있는 context
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            RoutineItem.self,
            RoutineHistory.self,
            TaskList.self
        ])
        
        //디스크에 데이터를 저장하지 않고 메모리에만 저장 = isStoredInMemoryOnly = ture  빠르지만 임시적임
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func insertSampleData() {
        
    }
}
