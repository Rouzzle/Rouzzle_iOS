//
//  TaskListView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 3/11/25.
//

import SwiftUI

struct TaskListView: View {
    let routine: RoutineItem
    @Binding var path: NavigationPath
    @State private var showTimerView = false
    @State private var isShowingRoutineSettingsSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
    @State private var isShowingEditRoutineSheet: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .customNavigationBar(title: "\(routine.emoji) \(routine.title)")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingRoutineSettingsSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.ptSemiBold(size: 20))
                }
            }
        }
        .sheet(isPresented: $isShowingRoutineSettingsSheet) {
            RoutineSettingsSheet(
                isShowingEditRoutineSheet: $isShowingEditRoutineSheet,
                isShowingDeleteAlert: $isShowingDeleteAlert
            )
            .presentationDetents([.fraction(0.25)])
        }
        .customAlert(
            isPresented: $isShowingDeleteAlert,
            title: "해당 루틴을 삭제합니다",
            message: "삭제 버튼 선택 시, 루틴 데이터는\n삭제되며 복구되지 않습니다.",
            primaryButtonTitle: "삭제",
            primaryAction: {
//                routineStore.deleteRoutine(
//                    modelContext: modelContext,
//                    completeAction: completeAction,
//                    dismiss: { dismiss() }
//                )
                dismiss()
            }
        )
    }
}

#Preview {
    NavigationStack {
        TaskListView(routine: RoutineItem.sampleData[0], path: .constant(NavigationPath()))
    }
}
