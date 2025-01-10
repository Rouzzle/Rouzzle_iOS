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
    @Attribute(.unique) var id: String
    var title: String
    var emoji: String
    var repeatCount: Int?
    var interval: Int?
    var dayStartTime: [Int: String]
    var alarmIDs: [Int: String]?
    var userId: String
    
    @Relationship(deleteRule: .cascade)
    var taskList: [TaskList] = []
    
    var isCompleted: Bool {
        return taskList.allSatisfy { $0.isCompleted }
    }
    
    init(
        id: String = "",
        title: String,
        emoji: String,
        dayStartTime: [Int: String],
        repeatCount: Int? = nil,
        interval: Int? = nil,
        alarmIDs: [Int: String]? = nil,
        userId: String = ""
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.dayStartTime = dayStartTime
        self.repeatCount = repeatCount
        self.interval = interval
        self.alarmIDs = alarmIDs
        self.userId = userId
    }
    
}

@Model
final class TaskList: Identifiable {
    @Attribute(.unique) var id = UUID()
    var title: String
    var emoji: String
    var timer: Int
    var elapsedTime: Int?
    var isCompleted: Bool = false
    
    @Relationship(inverse: \RoutineItem.taskList)
    var routineItem: RoutineItem?

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
        TaskList(title: "술 마시기", emoji: "🍺", timer: 30, isCompleted: false)
    ]
}
