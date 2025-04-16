//
//  StatisticView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI
import _SwiftData_SwiftUI
import Charts
struct StatisticView: View {
    @State private var month: Date = Date()
    @State private var selectedRoutine: RoutineItem = StatisticUtil.summaryRoutine
    @Query private var routineHistories: [RoutineHistory]
    let routines: [RoutineItem]
  
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                Text("통계")
                    .font(.ptSemiBold(.title2))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        SelectedRoutineButton(title: "요약", selected: selectedRoutine == StatisticUtil.summaryRoutine) {
                            selectedRoutine = StatisticUtil.summaryRoutine
                        }
                        .padding(.leading)
                        
                        ForEach(routines, id: \.id) { routine in
                            let selected = routine == selectedRoutine
                            SelectedRoutineButton(title: routine.title, selected: selected) {
                                selectedRoutine = routine
                            }
                        }
                    }
                }
                .padding(.bottom, 32)
                
                if(selectedRoutine == StatisticUtil.summaryRoutine) {
                    RoutineMaxStreakView(routineHistories: routineHistories)
                    HStack {
                        Text("월간 성공률")
                            .padding(.leading)
                            .font(.ptBold())
                        Spacer()
                        RoutineMonthSelectorView(month: $month)
                    }
                    RoutinePercentageView(routinehistories: routineHistories, date: month)
                } else {
                    RoutineSummaryView(selectedRoutine: selectedRoutine, proxy: proxy, month: $month)
                }
                Spacer()
            }
        }
    }
}

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

struct RoutineMonthSelectorView: View {
    
    @Binding var month: Date
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.basic)
                }
                
                Text(month.formattedCalenderDate)
                    .padding(.horizontal, 6)
                
                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.basic)
                }
            }
            
        }
        .padding()
    }
    func changeMonth(by value: Int) {
        self.month = Calendar.current.date(byAdding: .month, value: value, to: month) ?? month
    }
}

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

struct SelectedRoutineButton: View {
    private let title: String
    private let selected: Bool
    let action: () -> Void
    
    init(title: String, selected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.selected = selected
        self.action = action
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.ptSemiBold())
                .foregroundStyle(selected ? .accent : Color(uiColor: .systemGray))
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(selected ? .rzfcfff0 : .white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(selected ? Color.accentColor : Color(uiColor: .systemGray), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 40))
            
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    StatisticView(routines: RoutineItem.sampleData)
}
