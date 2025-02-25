//
//  SwiftDataService.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/19/25.
//

import Foundation
import SwiftData
import SwiftUI

enum SwiftDataServiceError: Error {
    case saveFailed(Error)
    case deleteFailed(Error)
}

/// 데이터 관련 작업(루틴, TaskList)을 관리하는 싱글톤 클래스
@MainActor
final class SwiftDataService {
    
    var context: ModelContext
    
    // 생성 시 외부에서 ModelContainer 주입
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - 루틴 관련 메서드
    func addRoutine(_ routine: RoutineItem) throws {
        context.insert(routine)
        try saveContext()
    }
    
    func deleteRoutine(_ routine: RoutineItem) throws {
        context.delete(routine)
        try saveContext()
    }
    
    func deleteAllRoutines() throws {
        let fetchDescriptor = FetchDescriptor<RoutineItem>()
        do {
            let userRoutines = try context.fetch(fetchDescriptor)
            for routine in userRoutines {
                context.delete(routine)
            }
            try saveContext()
        } catch {
            print("❌ SwiftData: 루틴 삭제 실패: \(error.localizedDescription)")
            throw SwiftDataServiceError.deleteFailed(error)
        }
    }
    
    func resetRoutine(from routine: RoutineItem) throws {
        for task in routine.taskList {
            context.delete(task)
        }
        routine.taskList.removeAll()
        try saveContext()
    }
    
    // MARK: - Task 관련 메서드
    func addTask(to routineItem: RoutineItem, task: TaskList)  {
        task.routineItem = routineItem
        routineItem.taskList.append(task)
        context.insert(task)
       // try saveContext()
    }
    
    func deleteTask(from routineItem: RoutineItem, task: TaskList) throws {
        if let index = routineItem.taskList.firstIndex(of: task) {
            routineItem.taskList.remove(at: index)
        }
        context.delete(task)
        try saveContext()
    }
    
    // MARK: - Private Method
    private func saveContext() throws {
        do {
            try context.save()
            print("성공")
        } catch {
            print("❌ Failed to save context: \(error.localizedDescription)")
            throw SwiftDataServiceError.saveFailed(error)
        }
    }
}
