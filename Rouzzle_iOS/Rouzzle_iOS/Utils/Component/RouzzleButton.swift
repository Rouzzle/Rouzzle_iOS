//
//  RouzzleButton.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/15/25.
//

import SwiftUI
/// 모든 버튼 유형
enum ButtonType: String {
    case start = "시작하기"
    case addTask = "할 일 추가"
    case refreshRecommendations = "추천 새로고침"
    case save = "저장하기"
    case complete = "완료"
    case next = "다음"
    case addtoroutine = "내 루틴에 추가하기"
    case timerStart = "START"
}

/// 버튼은 type 만을 넘겨주고 동일하게 사용할 수 있도록
struct RouzzleButton: View {
    let buttonType: ButtonType
    let disabled: Bool
    let action: () -> Void
    
    init(
        buttonType: ButtonType,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.buttonType = buttonType
        self.disabled = disabled
        self.action = action
    }
    var body: some View {
        Button(action: action) {
            Text("\(buttonType.rawValue)")
                .font(.ptBold())
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(disabled ? Color.gray.opacity(0.3) : .accent)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(disabled)
    }
}
