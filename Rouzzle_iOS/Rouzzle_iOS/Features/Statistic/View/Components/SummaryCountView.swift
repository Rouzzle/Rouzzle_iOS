//
//  SummaryCountView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI

struct SummaryCountView: View {
    let selectedRoutine: RoutineItem
    let proxy: GeometryProxy

    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 12) {
                Text("\(selectedRoutine.currentStreak())")
                    .font(.ptBold(.title3))
                Text("현재 연속일")
                    .font(.ptRegular(.body))
                    .foregroundStyle(.rz999999)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            Divider()
            VStack(spacing: 12) {
                Text("\(selectedRoutine.longestStreak())")
                    .font(.ptBold(.title3))
                Text("최대 연속일")
                    .font(.ptRegular(.body))
                    .foregroundStyle(.rz999999)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            Divider()
            VStack(spacing: 12) {
                Text("\(selectedRoutine.totalDaysCount())")
                    .font(.ptBold(.title3))
                Text("누적일")
                    .font(.ptRegular(.body))
                    .foregroundStyle(.rz999999)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: proxy.size.height * 0.15)
        .background(.rzf9F9F9)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}