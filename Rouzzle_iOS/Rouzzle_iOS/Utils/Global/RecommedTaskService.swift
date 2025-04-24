//
//  RecommedTaskService.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 4/24/25.
//

import Foundation

final class RecommendTaskService: RecommendTaskServiceProtocol {
    func fetchRecommendedTasks(time: Date, excluding titles: [String]) -> [RecommendTodoTask] {
        let timeSet = time.getTimeCategory()
        return RecommendTaskData.getRecommendedTasks(for: timeSet, excluding: titles)
    }
}
