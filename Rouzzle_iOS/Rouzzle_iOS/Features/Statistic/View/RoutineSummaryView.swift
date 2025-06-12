//
//  RoutineSummaryView.swift
//  Rouzzle_iOS
//
//  Created by 김동경 on 4/2/25.
//

import SwiftUI

struct RoutineSummaryView: View {
    let selectedRoutine: RoutineItem
    let proxy: GeometryProxy // 부모 전체화면 사이즈 크기
    @Binding var month: Date

    var body: some View {
        VStack {
            SummaryCountView(selectedRoutine: selectedRoutine, proxy: proxy)
            HStack {
                Text("월간 요약")
                    .font(.ptBold())
                Spacer()
                RoutineMonthSelectorView(month: $month)
            }
            .padding(.horizontal)
            CalendarView(month: $month, selectedRoutine: selectedRoutine)
                .padding(.top)
        }
    }
}



