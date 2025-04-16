//
//  RoutineCompleteViewModel.swift
//  Rouzzle_iOS
//
//  Created by Hyojeong on 4/8/25.
//

import Foundation
import Factory
import SwiftData

@Observable
final class RoutineCompleteViewModel {
    @ObservationIgnored
    @Injected(\.swiftDataService) private var swiftDataService: SwiftDataServiceProtocol
    
    let routine: RoutineItem
    let startTime: Date?
    let endTime: Date?
    
    init(routine: RoutineItem, startTime: Date? = nil, endTime: Date? = nil) {
        self.routine = routine
        self.startTime = startTime
        self.endTime = endTime
    }
    
    // 루틴 이름(이모지 + 이름)
    var routineTitle: String {
        return "\(routine.emoji)  \(routine.title)"
    }
    
    // 루틴 시작/완료 시간
    var routineTimeRange: String {
        guard let start = startTime, let end = endTime else { return "시간 정보 없음" }
        return "\(start.toTimeString()) ~ \(end.toTimeString())"
    }
    
    // 누적일
    var totalDays: Int {
        return routine.totalDaysCount()
    }
    
    // 연속일
    var longestDays: Int {
        return routine.longestStreak()
    }
    
    // 완료된 할일 리스트
    var completedTasks: [TaskList] {
        return routine.taskList.filter { task in
            // TaskList가 연결된 TaskHistory 중 하나라도 완료되었으면 완료로 간주
            task.taskHistories.contains(where: { $0.isCompleted })
        }
    }
}
