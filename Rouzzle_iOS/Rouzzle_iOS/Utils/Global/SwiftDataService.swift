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
    static let shared = SwiftDataService()
    
    let container: ModelContainer
    /// 기본적으로 mainContext를 사용 (앱의 규모나 동시성 요구사항에 따라 백그라운드 Context 도입 고려)
    var context: ModelContext {
        container.mainContext
    }
    
    // 초기화 시 ModelContainer를 생성하여 내부에 보관
    private init() {
        do {
            container = try ModelContainer(for: RoutineItem.self, TaskList.self)
        } catch {
            fatalError("❌ Could not initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 루틴 관련 메서드
    
    /// 루틴 추가
    func addRoutine(_ routine: RoutineItem) throws {
        context.insert(routine)
        try saveContext()
    }
    
    /// 루틴 삭제
    func deleteRoutine(_ routine: RoutineItem) throws {
        context.delete(routine)
        try saveContext()
    }
    
    /// 모든 루틴 일괄 삭제
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
    
    /// 해당 루틴의 TaskList 초기화 (reset)
    func resetRoutine(from routine: RoutineItem) throws {
        for task in routine.taskList {
            context.delete(task)
        }
        routine.taskList.removeAll()
        try saveContext()
    }
    
    // MARK: - Task 관련 메서드
    
    /// 할 일(Task) 추가
    func addTask(to routineItem: RoutineItem, _ task: TaskList) throws {
        task.routineItem = routineItem
        routineItem.taskList.append(task)
        context.insert(task)
        try saveContext()
    }
    
    /// 개별 Task 삭제
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
        } catch {
            print("❌ Failed to save context: \(error.localizedDescription)")
            throw SwiftDataServiceError.saveFailed(error)
        }
    }
}
