//
//  RecommendTaskData.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/15/25.
//

import Foundation
enum TimeCategory {
    case morning
    case afternoon
    case evening
    case night
}

struct RecommendTodoTask: Hashable {
    let emoji: String
    let title: String
    let timer: Int // 분 단위
    
    func toTaskList() -> TaskList {
        return TaskList(title: title, emoji: emoji, timer: timer)
    }
    
    func toRoutineTask() -> RoutineTask {
        return RoutineTask(title: title, emoji: emoji, timer: timer)
    }
}

struct RoutineCompletion: Codable, Hashable {

    var routineId: String // 루틴 id
    var userId: String // 유저 uid
    var date: Date // 완료 여부를 추적할 날짜
    var taskCompletions: [TaskCompletion] // 각 할 일의 완료 상태}
    
    /// TaskCompletion 완성 다 되었는지 확인하는 연산 프로퍼티
    var isCompleted: Bool {
        return taskCompletions.allSatisfy { $0.isComplete }
    }
}

struct TaskCompletion: Codable, Hashable {
    var title: String // 할일 제목
    var emoji: String // 이모지
    var timer: Int // 할일 타이머
    var isComplete: Bool // 완성됨?
    
    func toTaskList() -> TaskList {
        return TaskList(title: title, emoji: emoji, timer: timer, isCompleted: isComplete)
    }
}


struct RoutineTask: Codable, Hashable {
    var title: String // 할일 제목
    var emoji: String // 이모지
    var timer: Int // 타이머
    
    func toTaskList() -> TaskList {
        return TaskList(title: title, emoji: emoji, timer: timer)
    }
    
    func toTaskCompletion() -> TaskCompletion {
        return TaskCompletion(title: title, emoji: emoji, timer: timer, isComplete: false)
    }
}


struct RecommendTaskData {
    
    static let recommendedTasks: [TimeCategory: [RecommendTodoTask]] = [
           .morning: [
               RecommendTodoTask(emoji: "🏃‍♂️", title: "아침 운동하기", timer: 1800),
               RecommendTodoTask(emoji: "🍳", title: "아침 식사 준비하기", timer: 1200),
               RecommendTodoTask(emoji: "🧘‍♂️", title: "명상하기", timer: 1200),
               RecommendTodoTask(emoji: "📰", title: "뉴스 보기", timer: 900),
               RecommendTodoTask(emoji: "☕️", title: "커피 마시기", timer: 600),
               RecommendTodoTask(emoji: "📖", title: "독서하기", timer: 1800),
               RecommendTodoTask(emoji: "🎧", title: "좋아하는 음악 듣기", timer: 1200),
               RecommendTodoTask(emoji: "🚿", title: "샤워하기", timer: 1200),
               RecommendTodoTask(emoji: "🛌", title: "이불 정리", timer: 1200),
               RecommendTodoTask(emoji: "🍽", title: "요리하기", timer: 1800),
               RecommendTodoTask(emoji: "🏋️‍♂️", title: "가벼운 운동하기", timer: 1200),
               RecommendTodoTask(emoji: "🌞", title: "산책하기", timer: 1200)
           ],
           .afternoon: [
               RecommendTodoTask(emoji: "🥗", title: "점심 식사하기", timer: 1800),
               RecommendTodoTask(emoji: "💻", title: "프로젝트 작업하기", timer: 120),
               RecommendTodoTask(emoji: "📞", title: "전화 통화하기", timer: 1200),
               RecommendTodoTask(emoji: "📚", title: "학습하기", timer: 2700),
               RecommendTodoTask(emoji: "🍽", title: "요리하기", timer: 1800),
               RecommendTodoTask(emoji: "🌞", title: "산책하기", timer: 900),
               RecommendTodoTask(emoji: "📝", title: "점심 계획 세우기", timer: 300)
           ],
           .evening: [
               RecommendTodoTask(emoji: "🍲", title: "저녁 식사 준비하기", timer: 2700),
               RecommendTodoTask(emoji: "📖", title: "독서하기", timer: 1800),
               RecommendTodoTask(emoji: "👨‍👩‍👧‍👦", title: "가족과 시간 보내기", timer: 3600),
               RecommendTodoTask(emoji: "🎬", title: "영화 보기", timer: 7200),
               RecommendTodoTask(emoji: "🛀", title: "목욕하기", timer: 1800),
               RecommendTodoTask(emoji: "🍽", title: "요리하기", timer: 1800),
               RecommendTodoTask(emoji: "🌞", title: "산책하기", timer: 900),
               RecommendTodoTask(emoji: "🛋", title: "휴식하기", timer: 1200)
           ],
           .night: [
               RecommendTodoTask(emoji: "🧘‍♂️", title: "명상하기", timer: 1200),
               RecommendTodoTask(emoji: "📓", title: "일기 쓰기", timer: 900),
               RecommendTodoTask(emoji: "🛏️", title: "잠자리 준비하기", timer: 600),
               RecommendTodoTask(emoji: "📱", title: "SNS 확인하기", timer: 1200),
               RecommendTodoTask(emoji: "🔍", title: "내일 계획 세우기", timer: 900),
               RecommendTodoTask(emoji: "🌙", title: "수면 준비하기", timer: 900),
               RecommendTodoTask(emoji: "📓", title: "오늘 하루 정리하기", timer: 600),
               RecommendTodoTask(emoji: "🌞", title: "산책하기", timer: 900),
               RecommendTodoTask(emoji: "🛀", title: "반신욕하기", timer: 1200),
               RecommendTodoTask(emoji: "🛋", title: "휴식하기", timer: 1200)

           ]
       ]

    static func getRecommendedTasks(for category: TimeCategory, excluding existingTitles: [String], randomCount: Int = 3) -> [RecommendTodoTask] {
          // 해당 시간대의 모든 할 일을 가져오기.
          guard let tasksForCategory = recommendedTasks[category] else {
              return []
          }
          
          // 기존 제목과 중복되지 않는 할 일만 필터링.
        let filteredTasks = tasksForCategory.filter { !existingTitles.contains($0.title) }.shuffled()
          
          // randomCount가 0보다 클 경우, 지정된 개수만큼 무작위로 선택합니다.
          if randomCount > 0 && filteredTasks.count > randomCount {
              return Array(filteredTasks.shuffled().prefix(randomCount))
          } else {
              return filteredTasks
          }
      }
}
