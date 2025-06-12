//
//  RoutineMaxStreakView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI

struct RoutineMaxStreakView: View {
    let routineHistories: [RoutineHistory]
    
    var body: some View {
        VStack(spacing: 12) {
            if routineHistories.isEmpty {
                Text("루틴 기록이 없습니다.")
                    .font(.ptMedium())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("루틴을 생성하고 실행해 보세요!!")
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                let summary = StatisticUtil.shared.computeStreaks(from: routineHistories)
                Text("나의 최대 연속 기록이에요.")
                    .font(.ptBold(.title3))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(Array(summary.keys), id: \.id) { routine in
                    if let streak = summary[routine] {
                        Text("\(routine.title): \(streak)일")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.rzf9F9F9)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}