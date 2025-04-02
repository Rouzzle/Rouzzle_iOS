//
//  RecommendCard.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 4/2/25.
//

import Foundation

struct Card: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var subTitle: String?
    let imageName: String
    let fullText: String
    let routines: [RoutineTask]
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - 더미 데이터
// swiftlint:disable type_body_length
struct DummyCardData {
    static let celebrityCards: [Card] = [
        Card(
            title: "오타니 쇼헤이",
            subTitle: "초보자 추천",
            imageName: "⚾️",
            fullText: "오타니 쇼헤이는 세계적인 야구 선수로, 그의 하루는 철저한 관리와 노력으로 이루어져 있습니다. 아침부터 밤까지 최상의 컨디션을 유지하기 위한 특별한 루틴을 따릅니다.",
            routines: [
                RoutineTask(title: "새벽 기상 및 스트레칭", emoji: "🙆🏻", timer: 900),
                RoutineTask(title: "아침 웨이트 훈련", emoji: "🏃", timer: 3600),
                RoutineTask(title: "점심 고단백 식단", emoji: "🍱", timer: 1800),
                RoutineTask(title: "야간 회복 운동", emoji: "🌌", timer: 1800)
            ]
        ),
        Card(
            title: "앤드류 후버만",
            imageName: "🧬",
            fullText: "앤드류 후버만은 신경과학자로, 뇌 건강과 신체 건강을 위한 과학적 루틴을 실천합니다. 그는 규칙적인 운동과 명상으로 정신과 신체의 균형을 유지합니다.",
            routines: [
                RoutineTask(title: "아침 2시간 운동", emoji: "🏋️", timer: 7200),
                RoutineTask(title: "단백질 위주 아침 식사", emoji: "🍳", timer: 1800),
                RoutineTask(title: "명상 및 집중 훈련", emoji: "🧘‍♂️", timer: 1200),
                RoutineTask(title: "저녁 수면 준비", emoji: "🌙", timer: 2400)
            ]
        ),
        Card(
            title: "팀 페리스",
            imageName: "📚",
            fullText: "팀 페리스는 효율적이고 생산적인 삶을 지향하며, 하루를 철저히 계획하여 시간 관리를 극대화합니다. 그의 루틴은 균형 잡힌 하루를 만듭니다.",
            routines: [
                RoutineTask(title: "아침 명상 및 감사 일기 작성", emoji: "📝", timer: 20 * 60),
                RoutineTask(title: "건강한 식사 및 운동", emoji: "🥗", timer: 60 * 60),
                RoutineTask(title: "오후 책 읽기 및 학습", emoji: "📖", timer: 45 * 60),
                RoutineTask(title: "저녁 디지털 디톡스", emoji: "📵", timer: 30 * 60)
            ]
        ),
        Card(
            title: "킴 카다시안",
            imageName: "💎",
            fullText: "킴 카다시안은 성공적인 사업가이자 스타일 아이콘으로, 철저히 관리된 아침 루틴으로 하루를 시작합니다. 그녀는 운동과 스킨케어로 건강과 아름다움을 유지합니다.",
            routines: [
                RoutineTask(title: "아침 운동", emoji: "🏋️‍♀️", timer: 60 * 60),
                RoutineTask(title: "스킨케어 및 메이크업", emoji: "💄", timer: 40 * 60),
                RoutineTask(title: "비즈니스 미팅 준비", emoji: "📅", timer: 50 * 60),
                RoutineTask(title: "SNS 콘텐츠 관리", emoji: "📱", timer: 30 * 60)
            ]
        ),
        Card(
            title: "드웨인 존슨",
            imageName: "🪨",
            fullText: "드웨인 존슨은 강철 같은 체력과 정신력을 바탕으로 성공적인 삶을 살아갑니다. 그는 운동과 식사를 철저히 계획하여 일과 삶의 균형을 맞춥니다.",
            routines: [
                RoutineTask(title: "새벽 웨이트 트레이닝", emoji: "🏋️‍♂️", timer: 120 * 60),
                RoutineTask(title: "아침 고단백 식사", emoji: "🥩", timer: 40 * 60),
                RoutineTask(title: "영화 촬영 및 휴식", emoji: "🎥", timer: 90 * 60),
                RoutineTask(title: "저녁 명상 및 수면 관리", emoji: "🛌", timer: 30 * 60)
            ]
        )
    ]
    
    static let morningCards: [Card] = [
        Card(
            title: "상쾌한 아침 루틴",
            subTitle: "미라클 모닝",
            imageName: "☀️",
            fullText: "몸과 마음을 깨우는 상쾌한 하루의 시작.",
            routines: [
                RoutineTask(title: "기상 후 스트레칭", emoji: "🙆‍♀️", timer: 10 * 60),
                RoutineTask(title: "따뜻한 물 한 잔 마시기", emoji: "💧", timer: 5 * 60),
                RoutineTask(title: "창문 열고 환기하기", emoji: "🌬️", timer: 3 * 60),
                RoutineTask(title: "간단한 명상", emoji: "🧘‍♀️", timer: 10 * 60)
            ]
        ),
        Card(
            title: "건강한 아침 습관",
            imageName: "🍎",
            fullText: "신체를 건강하게 유지하기 위한 필수 아침 활동.",
            routines: [
                RoutineTask(title: "가벼운 아침 운동", emoji: "🏃‍♂️", timer: 20 * 60),
                RoutineTask(title: "건강한 식단 준비", emoji: "🥗", timer: 15 * 60),
                RoutineTask(title: "비타민 섭취", emoji: "💊", timer: 5 * 60),
                RoutineTask(title: "수분 섭취 알람 설정", emoji: "⏰", timer: 1 * 60)
            ]
        ),
        Card(
            title: "생산적인 아침 시간",
            imageName: "🚀",
            fullText: "하루를 효율적으로 시작할 수 있는 생산성 루틴.",
            routines: [
                RoutineTask(title: "오늘의 할 일 작성", emoji: "📝", timer: 15 * 60),
                RoutineTask(title: "중요한 이메일 확인", emoji: "📧", timer: 10 * 60),
                RoutineTask(title: "짧은 독서", emoji: "📖", timer: 20 * 60),
                RoutineTask(title: "하루 목표 설정", emoji: "🎯", timer: 10 * 60)
            ]
        ),
        Card(
            title: "여유로운 아침 시간",
            imageName: "☕️",
            fullText: "바쁜 일상 속에서도 여유를 즐길 수 있는 루틴.",
            routines: [
                RoutineTask(title: "느긋한 음악 감상", emoji: "🎶", timer: 15 * 60),
                RoutineTask(title: "커피나 차 마시기", emoji: "☕️", timer: 10 * 60),
                RoutineTask(title: "반려동물과의 산책", emoji: "🐾", timer: 20 * 60),
                RoutineTask(title: "창밖 풍경 바라보기", emoji: "🌅", timer: 5 * 60)
            ]
        )
    ]
    
    static let eveningCards: [Card] = [
        Card(
            title: "편안한 저녁 루틴",
            subTitle: "편안한 밤",
            imageName: "🌙",
            fullText: "하루를 마무리하며 몸과 마음을 안정시키는 편안한 저녁 루틴입니다.",
            routines: [
                RoutineTask(title: "저녁 산책", emoji: "🚶‍♀️", timer: 30 * 60),
                RoutineTask(title: "명상으로 마음 정리", emoji: "🧘‍♀️", timer: 15 * 60),
                RoutineTask(title: "가벼운 스트레칭", emoji: "🙆", timer: 10 * 60),
                RoutineTask(title: "차분한 음악 감상", emoji: "🎶", timer: 20 * 60)
            ]
        ),
        Card(
            title: "건강한 저녁 루틴",
            imageName: "🍲",
            fullText: "건강을 지키기 위한 저녁 습관으로 활력을 충전하세요.",
            routines: [
                RoutineTask(title: "건강한 저녁 식사 준비", emoji: "🥗", timer: 40 * 60),
                RoutineTask(title: "따뜻한 차 마시기", emoji: "🍵", timer: 10 * 60),
                RoutineTask(title: "소화에 좋은 산책", emoji: "🚶", timer: 15 * 60),
                RoutineTask(title: "수분 섭취", emoji: "💧", timer: 5 * 60)
            ]
        ),
        Card(
            title: "생산적인 저녁 시간",
            imageName: "🖋",
            fullText: "하루를 정리하고 내일을 준비하는 생산성 루틴입니다.",
            routines: [
                RoutineTask(title: "오늘의 성과 기록", emoji: "📓", timer: 15 * 60),
                RoutineTask(title: "내일의 할 일 작성", emoji: "📝", timer: 20 * 60),
                RoutineTask(title: "짧은 자기 계발 시간", emoji: "📖", timer: 30 * 60),
                RoutineTask(title: "전자기기 정리 및 충전", emoji: "🔌", timer: 5 * 60)
            ]
        ),
        Card(
            title: "숙면을 위한 준비",
            imageName: "🛌",
            fullText: "편안한 수면을 위한 저녁 준비 루틴입니다.",
            routines: [
                RoutineTask(title: "수면 전 독서", emoji: "📚", timer: 20 * 60),
                RoutineTask(title: "따뜻한 목욕", emoji: "🛁", timer: 30 * 60),
                RoutineTask(title: "수면 환경 정리", emoji: "🛏", timer: 10 * 60),
                RoutineTask(title: "가벼운 명상", emoji: "🧘‍♂️", timer: 15 * 60)
            ]
        )
    ]
    
    static let healthCards: [Card] = [
        Card(
            title: "활기찬 하루를 위한 운동",
            subTitle: "건강관리",
            imageName: "🏋️‍♀️",
            fullText: "몸과 마음을 튼튼히! 활기찬 하루를 만들어주는 운동 루틴입니다.",
            routines: [
                RoutineTask(title: "유산소 운동", emoji: "🏃", timer: 30 * 60),
                RoutineTask(title: "근력 강화 훈련", emoji: "🏋️", timer: 20 * 60),
                RoutineTask(title: "요가와 스트레칭", emoji: "🧘‍♀️", timer: 15 * 60),
                RoutineTask(title: "운동 후 수분 섭취", emoji: "💧", timer: 5 * 60)
            ]
        ),
        Card(
            title: "건강한 식습관 만들기",
            imageName: "🥗",
            fullText: "영양 가득한 식사로 건강을 유지하는 하루 식단 루틴입니다.",
            routines: [
                RoutineTask(title: "건강한 아침 식사 준비", emoji: "🍳", timer: 15 * 60),
                RoutineTask(title: "신선한 야채와 과일 섭취", emoji: "🥦", timer: 10 * 60),
                RoutineTask(title: "정제된 설탕 줄이기", emoji: "🍬", timer: 1 * 60),
                RoutineTask(title: "물 8잔 마시기 목표", emoji: "💧", timer: 1 * 60)
            ]
        ),
        Card(
            title: "건강 관리와 정기적인 체크",
            imageName: "🩺",
            fullText: "내 몸을 점검하고 건강을 꾸준히 관리하는 습관입니다.",
            routines: [
                RoutineTask(title: "아침 체중 확인", emoji: "⚖️", timer: 2 * 60),
                RoutineTask(title: "혈압과 심박수 체크", emoji: "❤️", timer: 5 * 60),
                RoutineTask(title: "정기적인 건강 기록 작성", emoji: "📋", timer: 10 * 60),
                RoutineTask(title: "건강 관련 앱 사용", emoji: "📱", timer: 5 * 60)
            ]
        ),
        Card(
            title: "피로 회복과 면역력 강화",
            imageName: "💊",
            fullText: "면역력을 강화하고 피로를 줄이는 건강 회복 루틴입니다.",
            routines: [
                RoutineTask(title: "비타민 및 영양제 섭취", emoji: "💊", timer: 5 * 60),
                RoutineTask(title: "깊고 안정적인 수면", emoji: "🛌", timer: 480 * 60), // 8시간
                RoutineTask(title: "정신적 피로 해소 명상", emoji: "🧘‍♂️", timer: 10 * 60),
                RoutineTask(title: "가벼운 낮잠", emoji: "🛌", timer: 20 * 60)
            ]
        )
    ]
    
    static let petCards: [Card] = [
        Card(
            title: "아침 반려동물 케어",
            imageName: "🌅",
            fullText: "반려동물이 상쾌한 아침을 시작할 수 있도록 돌보는 루틴입니다.",
            routines: [
                RoutineTask(title: "아침 간식 챙겨주기", emoji: "🍖", timer: 5 * 60),
                RoutineTask(title: "아침 산책 및 운동", emoji: "🐕", timer: 20 * 60),
                RoutineTask(title: "물그릇과 밥그릇 청소", emoji: "🧽", timer: 10 * 60),
                RoutineTask(title: "털 브러싱", emoji: "🪮", timer: 10 * 60)
            ]
        ),
        Card(
            title: "반려동물과 놀아주기",
            imageName: "🎾",
            fullText: "반려동물과의 놀이 시간으로 행복한 유대감을 형성하세요.",
            routines: [
                RoutineTask(title: "실내 공놀이", emoji: "⚾️", timer: 15 * 60),
                RoutineTask(title: "간식 숨기기 게임", emoji: "🦴", timer: 10 * 60),
                RoutineTask(title: "짧은 산책", emoji: "🚶", timer: 20 * 60),
                RoutineTask(title: "보호자와 교감 시간", emoji: "❤️", timer: 15 * 60)
            ]
        ),
        Card(
            title: "건강 관리 루틴",
            imageName: "🩺",
            fullText: "반려동물의 건강을 돌보기 위한 루틴입니다.",
            routines: [
                RoutineTask(title: "발톱 관리", emoji: "✂️", timer: 10 * 60),
                RoutineTask(title: "눈과 귀 청소", emoji: "👂", timer: 10 * 60),
                RoutineTask(title: "정기적인 몸 상태 점검", emoji: "🩺", timer: 15 * 60),
                RoutineTask(title: "산책 후 발 세척", emoji: "🧼", timer: 5 * 60)
            ]
        ),
        Card(
            title: "저녁 반려동물 케어",
            imageName: "🌙",
            fullText: "반려동물이 하루를 편안히 마무리할 수 있도록 도와주는 루틴입니다.",
            routines: [
                RoutineTask(title: "저녁 산책", emoji: "🌌", timer: 20 * 60),
                RoutineTask(title: "편안한 공간 만들어주기", emoji: "🛏", timer: 10 * 60),
                RoutineTask(title: "놀이 후 정리", emoji: "🧸", timer: 10 * 60),
                RoutineTask(title: "반려동물 상태 확인", emoji: "🔍", timer: 5 * 60)
            ]
        )
    ]
    
    static let productivityCards: [Card] = [
        Card(
            title: "효율적인 아침 시간",
            imageName: "⏰",
            fullText: "아침 시간을 활용해 하루를 효율적으로 시작하는 루틴입니다.",
            routines: [
                RoutineTask(title: "오늘의 할 일 작성", emoji: "📝", timer: 10 * 60),
                RoutineTask(title: "짧은 독서", emoji: "📖", timer: 20 * 60),
                RoutineTask(title: "중요한 이메일 확인", emoji: "📧", timer: 15 * 60),
                RoutineTask(title: "집중 타이머 설정", emoji: "⏱", timer: 5 * 60)
            ]
        ),
        Card(
            title: "집중력 높이기",
            imageName: "🎯",
            fullText: "집중력을 유지하며 업무와 학습을 효율적으로 처리하는 루틴입니다.",
            routines: [
                RoutineTask(title: "작업 환경 정리", emoji: "🧹", timer: 10 * 60),
                RoutineTask(title: "작업 타이머 맞추기 (Pomodoro)", emoji: "⏲️", timer: 25 * 60),
                RoutineTask(title: "작은 목표 완료", emoji: "✅", timer: 15 * 60),
                RoutineTask(title: "5분 간단한 휴식", emoji: "☕️", timer: 5 * 60)
            ]
        ),
        Card(
            title: "생산적인 오후 시간",
            imageName: "☀️",
            fullText: "오후 시간을 활용하여 더 많은 성과를 얻을 수 있는 루틴입니다.",
            routines: [
                RoutineTask(title: "중요한 프로젝트 진행", emoji: "📊", timer: 60 * 60),
                RoutineTask(title: "회의 준비 및 참여", emoji: "💼", timer: 30 * 60),
                RoutineTask(title: "정리 및 메모 정리", emoji: "📂", timer: 20 * 60),
                RoutineTask(title: "다음 작업 우선순위 확인", emoji: "📋", timer: 10 * 60)
            ]
        ),
        Card(
            title: "저녁 시간 생산성 관리",
            imageName: "🌙",
            fullText: "하루를 마무리하며 내일의 생산성을 준비하는 루틴입니다.",
            routines: [
                RoutineTask(title: "오늘의 성과 기록", emoji: "📓", timer: 15 * 60),
                RoutineTask(title: "내일의 목표 설정", emoji: "🎯", timer: 10 * 60),
                RoutineTask(title: "전자기기 정리 및 충전", emoji: "🔌", timer: 5 * 60),
                RoutineTask(title: "짧은 자기 계발 시간", emoji: "📘", timer: 30 * 60)
            ]
        )
    ]
    
    static let restCards: [Card] = [
        Card(
            title: "완전한 휴식",
            imageName: "🛋",
            fullText: "몸과 마음의 피로를 풀고 에너지를 재충전할 수 있는 휴식 루틴입니다.",
            routines: [
                RoutineTask(title: "좋아하는 음악 듣기", emoji: "🎶", timer: 15 * 60),
                RoutineTask(title: "따뜻한 목욕", emoji: "🛁", timer: 30 * 60),
                RoutineTask(title: "가벼운 낮잠", emoji: "🛌", timer: 20 * 60),
                RoutineTask(title: "스트레칭으로 몸 풀기", emoji: "🙆‍♂️", timer: 10 * 60)
            ]
        ),
        Card(
            title: "힐링 타임",
            imageName: "🌿",
            fullText: "마음을 안정시키고 평온한 시간을 보낼 수 있는 힐링 루틴입니다.",
            routines: [
                RoutineTask(title: "명상으로 마음 비우기", emoji: "🧘", timer: 15 * 60),
                RoutineTask(title: "따뜻한 차 마시기", emoji: "🍵", timer: 10 * 60),
                RoutineTask(title: "자연 속 산책", emoji: "🌳", timer: 20 * 60),
                RoutineTask(title: "기분 좋은 향기 즐기기", emoji: "🕯", timer: 5 * 60)
            ]
        ),
        Card(
            title: "취미와 여가",
            imageName: "🎨",
            fullText: "좋아하는 활동으로 하루의 활력을 더하는 여가 시간입니다.",
            routines: [
                RoutineTask(title: "독서로 마음의 양식 쌓기", emoji: "📚", timer: 30 * 60),
                RoutineTask(title: "간단한 그림 그리기", emoji: "🎨", timer: 20 * 60),
                RoutineTask(title: "좋아하는 영화 감상", emoji: "🎥", timer: 120 * 60),
                RoutineTask(title: "가벼운 게임 즐기기", emoji: "🎮", timer: 30 * 60)
            ]
        ),
        Card(
            title: "편안한 밤 휴식",
            imageName: "🌌",
            fullText: "하루를 마무리하며 심신의 안정을 찾는 밤 휴식 루틴입니다.",
            routines: [
                RoutineTask(title: "수면 환경 정리", emoji: "🛏", timer: 10 * 60),
                RoutineTask(title: "수면 전 독서", emoji: "📖", timer: 20 * 60),
                RoutineTask(title: "조명 낮추기", emoji: "💡", timer: 5 * 60),
                RoutineTask(title: "편안한 음악 듣기", emoji: "🎵", timer: 15 * 60)
            ]
        )
    ]
}
