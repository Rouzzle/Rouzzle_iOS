//
//  Container.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/28/25.
//

import Factory
import SwiftData

extension Container {
    // 앱 전체에서 공유할 ModelContainer
    static var modelContainer: ModelContainer!
    
    // SwiftDataServiceProtocol을 구현한 SwiftDataServiceImpl을 등록
    var swiftDataService: Factory<SwiftDataServiceProtocol> {
        Factory(self) { @MainActor in
            SwiftDataServiceImpl(modelContainer: Container.modelContainer)
        }
    }
    
    var recommendTaskService: Factory<RecommendTaskServiceProtocol> {
        Factory(self) {
            RecommendTaskService()
        }
    }
}
