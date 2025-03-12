//
//  RoutineItem.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import Foundation
import SwiftData

@Model
final class RoutineItem: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var emoji: String
    var repeatCount: Int?
    var interval: Int?
    var dayStartTime: [Int: String]
    var alarmIDs: [Int: String]?
    
    @Relationship(deleteRule: .cascade)
    var taskList: [TaskList] = []
     
    @Relationship(deleteRule: .cascade)
    var history: [RoutineHistory] = []
    
    //TODO: 삭제 되어야? -> history에서 isCompleted를 관리하는게 어때요?
    var isCompleted: Bool {
        return taskList.allSatisfy { $0.isCompleted }
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        emoji: String,
        dayStartTime: [Int: String],
        repeatCount: Int? = nil,
        interval: Int? = nil,
        alarmIDs: [Int: String]? = nil
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.dayStartTime = dayStartTime
        self.repeatCount = repeatCount
        self.interval = interval
        self.alarmIDs = alarmIDs
    }
    
}

@Model //TODO: 이름이 Task가 더 맞아보여요
final class TaskList: Identifiable {
    @Attribute(.unique) var id = UUID()
    var title: String
    var emoji: String
    var timer: Int
    var elapsedTime: Int?
    //TODO: 여기의 isCompleted도 taskHistory에서
    var isCompleted: Bool = false
    
    @Relationship(inverse: \RoutineItem.taskList)
    var routineItem: RoutineItem?
    
    @Relationship(deleteRule: .cascade)
    var taskHistories: [TaskHistory] = []

    init(
        id: UUID = UUID(),
        title: String,
        emoji: String,
        timer: Int,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.timer = timer
        self.isCompleted = isCompleted
    }
}

@Model
final class RoutineHistory: Identifiable {
    @Attribute(.unique) var id = UUID()
    var date: Date
    
    // 관계 설정: 특정 루틴에 대한 기록임을 명시합니다.
    @Relationship(inverse: \RoutineItem.history)
    var routine: RoutineItem?
    
    @Relationship(deleteRule: .cascade)
    var taskHistories: [TaskHistory] = []
    
    //TODO: 추가됨
    /// 모든 task를 다 완료했는지
    var isCompleted: Bool {
        return taskHistories.allSatisfy { $0.isCompleted }
    }
    
    //TODO: 추가됨
    /// task 성공율(두 자리 정수)
    var completeRate: Int {
        guard !taskHistories.isEmpty else { return 0 }
        let compoleteCount = taskHistories.filter { $0.isCompleted }.count
        return (compoleteCount * 100) / taskHistories.count
    }
       
    init(date: Date, routine: RoutineItem? = nil) {
        self.date = date
        self.routine = routine
    }
}

@Model
final class TaskHistory: Identifiable {
    @Attribute(.unique) var id = UUID()
    
    /// TaskList와의 관계 (어떤 Task인지 확인하기 위해)
    @Relationship(inverse: \TaskList.taskHistories)
    var task: TaskList?
    
    //TODO: 추가됨
    /// 해당 Task의 완료 여부
    var isCompleted: Bool
    
    /// RoutineHistory와의 관계: 해당 날짜의 루틴 수행 기록
    @Relationship(inverse: \RoutineHistory.taskHistories)
    var routineHistory: RoutineHistory?
    
    init(isCompleted: Bool, task: TaskList? = nil, routineHistory: RoutineHistory? = nil) {
        self.isCompleted = isCompleted
        self.task = task
        self.routineHistory = routineHistory
    }
}

extension RoutineItem {
    static let sampleData: [RoutineItem] = [
        RoutineItem(title: "아침 루틴", emoji: "🚬", dayStartTime: [1: "06:30"]),
        RoutineItem(title: "저녁 루틴", emoji: "🍺", dayStartTime: [1: "12:00"]),
        RoutineItem(title: "운동 루틴", emoji: "💪🏼", dayStartTime: [1: "18:00"])
    ]
}

extension TaskList {
    static let sampleData: [TaskList] = [
        TaskList(title: "밥 먹기", emoji: "🍚", timer: 3, isCompleted: false),
        TaskList(title: "양치 하기", emoji: "🪥", timer: 3, isCompleted: false),
        TaskList(title: "술 마시기", emoji: "🍺", timer: 30, isCompleted: false),
        TaskList(title: "음 그래 쉽지않아", emoji: "👺", timer: 30, isCompleted: true),
        TaskList(title: "이두 조져", emoji: "💪🏿", timer: 10, isCompleted: true),
        TaskList(title: "삼두 조져", emoji: "🦾", timer: 10, isCompleted: true),
        TaskList(title: "예비군", emoji: "🪖", timer: 10, isCompleted: true),
    ]
}

extension RoutineHistory {
    static var sampleData: [RoutineHistory] {
        let routine = RoutineItem.sampleData[0] // 아침 루틴
        let calendar = Calendar.current
        let today = Date()
        return (-30..<30).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: today)!
            return RoutineHistory(date: date, routine: routine)
        }
    }
}
