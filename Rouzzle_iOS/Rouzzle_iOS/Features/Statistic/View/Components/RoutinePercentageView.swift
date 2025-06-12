//
//  RoutinePercentageView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI

struct RoutinePercentageView: View {
    let routinehistories: [RoutineHistory]
    let date: Date
    @State private var animatedValue: Double = 0
    
    var body: some View {
        VStack {
            let routineMonthData = StatisticUtil.shared.computeMonthlyStatsForGroupedHistories(from: routinehistories, for: date)
            ForEach(Array(routineMonthData.keys), id: \.id) { routine in
                if let routineStat = routineMonthData[routine] {
                    let color = StatisticUtil.shared.statisPercentageColor(percentage: routineStat.completionPercentage)
                    HStack(spacing: 6) {
                        Text("\(routine.emoji)")
                        Text(routine.title)
                        GeometryReader { proxy in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(color)
                                .frame(
                                    width: proxy.size.width * (CGFloat(routineStat.completionPercentage) * 0.01),
                                    height: 18
                                )
                        }
                        .frame(height: 18)
                        Text("\(routineStat.completionPercentage)%")
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}