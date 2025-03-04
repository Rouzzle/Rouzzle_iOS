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
    
    var description: String {
        switch self {
        case .morning:
            return "상쾌한 아침 시작하기"
        case .afternoon:
            return "활기찬 오후 만들기"
        case .evening:
            return "하루를 편안히 마무리하기"
        case .night:
            return "휴식과 재충전 하기"
        }
    }
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

struct RecommendTaskWithDescription: Hashable {
    let emoji: String
    let title: String
    let timer: Int
    let description: String
    
    func toRecommendTodoTask() -> RecommendTodoTask {
        return RecommendTodoTask(emoji: emoji, title: title, timer: timer)
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
    
    // 설명이 포함된 추천 태스크 모음
        static let recommendedTasksWithDescription: [TimeCategory: [RecommendTaskWithDescription]] = [
            .morning: [
                RecommendTaskWithDescription(
                    emoji: "🛌",
                    title: "잠자리 정리",
                    timer: 180,
                    description: "매일 아침 잠자리를 정돈한다는 건 그날의 첫 번째 과업을 달성했다는 뜻이에요. 작지만 뭔가 해냈다는 성취감이 자존감으로 이어져요."
                ),
                RecommendTaskWithDescription(
                    emoji: "🧘🏻‍♀️",
                    title: "명상하기",
                    timer: 600,
                    description: "명상은 현재 상황을 직시하고, 사소한 일에 예민하게 반응하지 않도록 돕고, 침착한 태도를 유지하는 데 효과적이에요."
                ),
                RecommendTaskWithDescription(
                    emoji: "🙆🏻",
                    title: "스트레칭",
                    timer: 300,
                    description: "스트레칭으로 몸을 가볍게 풀어보세요. 아침의 나른함과 피로감을 덜어주며, 집중력도 높여줍니다."
                ),
                RecommendTaskWithDescription(
                    emoji: "🍵",
                    title: "차 마시기",
                    timer: 600,
                    description: "아침에 마시는 차는 정신을 맑게 해주는 탁월한 효과가 있어요. 어떤 차든 좋으니, 아침의 여유와 함께 차를 음미해보세요."
                )
            ],
            .afternoon: [
                RecommendTaskWithDescription(
                    emoji: "🥗",
                    title: "점심 가볍게 먹기",
                    timer: 1800,
                    description: "점심은 소화에 부담을 주지 않는 가벼운 음식으로 섭취하세요. 과한 포만감은 생산성을 저하시키는 주범이에요."
                ),
                RecommendTaskWithDescription(
                    emoji: "🦵🏻",
                    title: "다리 마사지하기",
                    timer: 300,
                    description: "책상에 오래 앉아 있었다면 다리를 부드럽게 마사지해보세요. 다리의 피로를 풀어주고 혈액순환을 촉진하여, 오후에도 가벼운 몸 상태를 유지할 수 있어요."
                ),
                RecommendTaskWithDescription(
                    emoji: "🚶🏻",
                    title: "가볍게 산책하기",
                    timer: 600,
                    description: "가벼운 산책으로 햇볕을 쬐고 바깥 공기를 마셔보세요. 소화를 돕고, 오후의 나른함을 예방할 수 있어요."
                ),
                RecommendTaskWithDescription(
                    emoji: "🧹️️",
                    title: "정리정돈",
                    timer: 300,
                    description: "책상과 주변을 정리하면, 집중력을 회복하고 깔끔한 환경에서 일할 수 있어요. 공간이 정돈되면 마음도 한결 편안해집니다."
                )
            ],
            .evening: [
                RecommendTaskWithDescription(
                    emoji: "🚿",
                    title: "따뜻한 샤워",
                    timer: 900,
                    description: "따뜻한 물로 샤워하여 하루의 피로를 씻어내고 마음도 함께 정리해보세요. 따뜻한 물은 혈액순환을 돕고 근육을 이완시켜 줍니다."
                ),
                RecommendTaskWithDescription(
                    emoji: "📚️️",
                    title: "독서하기",
                    timer: 600,
                    description: "저녁에는 좋아하는 책을 짧게라도 읽어보세요. 하루의 긴장과 스트레스를 잊고 마음의 평온을 찾는 시간을 가질 수 있습니다."
                ),
                RecommendTaskWithDescription(
                    emoji: "🎒️️",
                    title: "내일의 간단한 준비",
                    timer: 300,
                    description: "내일 입을 옷이나 필요한 물건을 미리 준비해 아침을 여유롭게 시작하세요. 간단한 준비가 아침을 더 편안하게 만들어줍니다."
                ),
                RecommendTaskWithDescription(
                    emoji: "📝",
                    title: "감사일기 쓰기",
                    timer: 600,
                    description: "오늘 하루 중 감사했던 순간들을 기록해보세요. 감사를 표현하는 것은 하루를 기분 좋게 마치고 내일을 준비하는 마음가짐에도 좋습니다."
                )
            ],
            .night: [
                RecommendTaskWithDescription(
                    emoji: "🛋️",
                    title: "마음껏 쉬기",
                    timer: 1200,
                    description: "소파나 침대에 편안하게 누워 아무 생각 없이 휴식을 취하세요. 단순히 몸과 마음을 쉬게 하는 것은 큰 에너지를 충전하는 데 도움이 됩니다."
                ),
                RecommendTaskWithDescription(
                    emoji: "🎨",
                    title: "간단한 취미 즐기기",
                    timer: 1800,
                    description: "음악 감상이나 그림 그리기 등 좋아하는 취미에 잠깐 빠져보세요. 작은 취미 활동이 스트레스를 줄이고 일상의 소소한 행복을 더해줍니다."
                ),
                RecommendTaskWithDescription(
                    emoji: "📺",
                    title: "차분한 영상 감상",
                    timer: 900,
                    description: "잔잔하고 편안한 영상을 보며 잠시 휴식을 취해보세요. 차분한 영상이 긴장을 풀어주고 편안한 마음 상태를 유지하는 데 도움을 줍니다."
                ),
                RecommendTaskWithDescription(
                    emoji: "🛀️️",
                    title: "온욕 또는 반신욕",
                    timer: 1200,
                    description: "따뜻한 물에 몸을 담가 피로를 푸는 온욕이나 반신욕을 즐겨보세요. 몸의 긴장을 풀고 혈액순환을 촉진하여 깊은 휴식을 돕습니다."
                )
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
    
    // 설명이 포함된 추천 태스크를 가져오는 메서드
    static func getRecommendedTasksWithDescription(for category: TimeCategory) -> [RecommendTaskWithDescription] {
        return recommendedTasksWithDescription[category] ?? []
    }
}
