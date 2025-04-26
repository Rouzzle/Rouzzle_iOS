//
//  TaskListViewModel.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 4/24/25.
//

import SwiftUI
import Factory

final class TaskListViewModel: ObservableObject {
    
    @Injected(\.swiftDataService) private var swiftDataService: SwiftDataServiceProtocol
    @Injected(\.recommendTaskService) private var recommendTaskService: RecommendTaskServiceProtocol
    
    @Published var routineItem: RoutineItem
    @Published var recommendTodoTask: [RecommendTodoTask] = [] {
        didSet {
            print("Recommend: \(recommendTodoTask.count)")
        }
    }
    @Published var routineTask: [RoutineTask]
    
    init(routineItem: RoutineItem) {
        self.routineItem = routineItem
        self.routineTask = routineItem.taskList.map{$0.toRoutineTask()}
    }
    
    func saveRoutineTasks(task: RoutineTask) {
        try? swiftDataService.addTask(to: routineItem, task: task.toTaskList())
        getRecommendTask()
    }
    
    func deleteRoutine() {
        try? swiftDataService.deleteRoutine(routineItem)
    }
    
    func getRecommendTask() {
        guard let firstTime = routineItem.dayStartTime.first?.value, let time = firstTime.toDate() else {
            return
        }
        let routineTitles = routineItem.taskList.map { $0.title }
        recommendTodoTask = recommendTaskService.fetchRecommendedTasks(time: time, excluding: routineTitles)
    }
    
    
    func addTask(from recommend: RecommendTodoTask, to routineItem: RoutineItem) {
        let task = recommend.toTaskList()
        try? swiftDataService.addTask(to: routineItem, task: task)
    }
}
