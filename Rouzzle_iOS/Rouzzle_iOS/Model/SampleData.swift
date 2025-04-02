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
            TaskList.self,
            TaskHistory.self
        ])
        
        //디스크에 데이터를 저장하지 않고 메모리에만 저장 = isStoredInMemoryOnly = ture  빠르지만 임시적임
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            insertSampleData()
            
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func insertSampleData() {
        let context = self.context
        let calendar = Calendar.current
        let today = Date()
        
        // 두 개의 루틴 생성 (각 루틴은 실행 요일이 다르게 설정됨)
        let routine1 = RoutineItem(
            title: "아침 루틴",
            emoji: "☀️",
            dayStartTime: [1: "06:30", 2: "08:20", 4: "10:00"]
        )
        let routine2 = RoutineItem(
            title: "저녁 루틴",
            emoji: "🌙",
            dayStartTime: [1: "18:30", 3: "09:30", 5: "04:00", 6: "14:00"]
        )
        
        // 각 루틴에 포함될 3개의 TaskList 생성
        let task1_r1 = TaskList(title: "밥 먹기", emoji: "🍚", timer: 30, isCompleted: false)
        let task2_r1 = TaskList(title: "양치하기", emoji: "🪥", timer: 5, isCompleted: false)
        let task3_r1 = TaskList(title: "운동하기", emoji: "💪", timer: 20, isCompleted: false)
        routine1.taskList.append(contentsOf: [task1_r1, task2_r1, task3_r1])
        
        let task1_r2 = TaskList(title: "텔레비전 시청", emoji: "📺", timer: 60, isCompleted: false)
        let task2_r2 = TaskList(title: "저녁 식사", emoji: "🍽", timer: 45, isCompleted: false)
        let task3_r2 = TaskList(title: "독서하기", emoji: "📖", timer: 30, isCompleted: false)
        routine2.taskList.append(contentsOf: [task1_r2, task2_r2, task3_r2])
        
        // context에 루틴 삽입
        context.insert(routine1)
        context.insert(routine2)
        
        // -30일부터 +30일까지 (총 61일치)
        for routine in [routine1, routine2] {
            // 루틴 실행 요일 목록 (dayStartTime의 키들)
            let validWeekdays = Set(routine.dayStartTime.keys)
            
            for offset in -30...30 {
                let date = calendar.date(byAdding: .day, value: offset, to: today)!
                // 날짜의 요일 추출 (Calendar의 .weekday: 1~7)
                let weekday = calendar.component(.weekday, from: date)
                
                // 현재 날짜의 요일이 해당 루틴의 실행 요일에 포함되어 있을 때만 생성
                if validWeekdays.contains(weekday) {
                    let history = RoutineHistory(date: date, routine: routine)
                    
                    let tasks = routine.taskList
                    let taskCount = tasks.count
                    
                    let pattern = abs(offset) % 3
                    let completedCount: Int
                    switch pattern {
                    case 0:
                        completedCount = taskCount                   // 100% 완료
                    case 1:
                        completedCount = taskCount / 2                 // 50% 완료
                    case 2:
                        completedCount = Int(Double(taskCount) * 0.8)    // 80% 완료
                    default:
                        completedCount = 0
                    }
                    
                    var taskHistories: [TaskHistory] = []
                    for (index, task) in tasks.enumerated() {
                        let isCompleted = index < completedCount // true로 할 시 루틴 하루도 안빼먹은 거임
                        let taskHistory = TaskHistory(isCompleted: isCompleted, task: task)
                        taskHistories.append(taskHistory)
                    }
                    history.taskHistories = taskHistories
                    context.insert(history)
                }
            }
        }
        
        do {
            try context.save()
            print("샘플 데이터 삽입 성공")
        } catch {
            print("샘플 데이터 저장 실패: \(error)")
        }
    }
}
