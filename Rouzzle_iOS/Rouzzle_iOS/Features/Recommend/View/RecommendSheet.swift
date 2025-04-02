//
//  RecommendSheet.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 4/2/25.
//

import SwiftUI

struct RecommendSheet: View {
    @Environment(\.dismiss) private var dismiss

    let tasks: [RecommendTodoTask]
    let routines: [RoutineItem]
    let saveRoutine: (RoutineItem?) -> Void

    @State private var selectedRoutineId: UUID?

    var selectedRoutine: RoutineItem? {
        routines.first(where: { $0.id == selectedRoutineId })
    }

    var body: some View {
        VStack(spacing: 16) {
            // 상단 버튼
            HStack {
                Button("닫기") {
                    dismiss()
                }
                .font(.headline)

                Spacer()

                Button("완료") {
                    saveRoutine(selectedRoutine)
                    dismiss()
                }
                .font(.headline)
            }
            .padding(.horizontal)

            Divider()

            // 루틴 선택 휠
            Picker("루틴 선택", selection: $selectedRoutineId) {
                ForEach(routines, id: \.id) { routine in
                    Text(routine.title).tag(Optional(routine.id))
                }
                Text("루틴 추가하기").tag(nil as UUID?)
            }
            .pickerStyle(.wheel)
        }
        .padding()
        .onAppear {
            selectedRoutineId = routines.first?.id
        }
    }
}

#Preview {
    RecommendSheet(
        tasks: [],
        routines: [],
        saveRoutine: { _ in }
    )
}
