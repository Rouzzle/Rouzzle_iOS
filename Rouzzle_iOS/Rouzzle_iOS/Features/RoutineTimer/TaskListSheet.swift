//
//  TaskListSheet.swift
//  Rouzzle_iOS
//
//  Created by Hyojeong on 3/4/25.
//

import SwiftUI

struct TaskListSheet: View {
    @Binding var tasks: [TaskList]
    @Binding var detents: Set<PresentationDetent>
    @Environment(\.dismiss) private var dismiss
    @State private var draggedItem: TaskList?
    @State private var showEditIcon = false
    @State private var tempTasks: [TaskList] = []
    var inProgressTask: TaskList?
    
    var body: some View {
        VStack(spacing: 35) {
            Text(showEditIcon ? "목록 수정" : "할일 목록")
                .font(.ptSemiBold(.title3))
                .padding(.top, 30)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(showEditIcon ? tempTasks : tasks) { task in
                        if showEditIcon {
                            // 순서 수정 버튼 눌렀을 때
                            TaskStatusRow(
                                taskStatus: task.isCompleted ? .completed : .pending,
                                emojiText: task.emoji,
                                title: task.title,
                                timeInterval: task.elapsedTime ?? task.timer,
                                showEditIcon: $showEditIcon,
                                showDeleteIcon: .constant(false),
                                onDelete: {}
                            )
                            .onDrag {
                                self.draggedItem = task
                                return NSItemProvider()
                            }
                            .onDrop(
                                of: [.text],
                                delegate: DropViewDelegate(
                                    item: task,
                                    items: $tempTasks,
                                    draggedItem: $draggedItem
                                )
                            )
                        } else {
                            // 순서 수정 버튼 안 눌렀을 때
                            TaskStatusRow(
                                taskStatus: task.id == inProgressTask?.id ? .inProgress :
                                    (task.isCompleted ? .completed : .pending),
                                emojiText: task.emoji,
                                title: task.title,
                                timeInterval: task.elapsedTime ?? task.timer,
                                showEditIcon: $showEditIcon,
                                showDeleteIcon: .constant(false)
                            )
                        }
                    }
                }
                .padding()
            }
            
            if showEditIcon {
                Button {
                    tasks = tempTasks
                    dismiss()
                } label: {
                    Text("완료")
                        .underline()
                        .font(.ptRegular())
                }
                .padding(.bottom, 20)
            } else {
                Button {
                    tempTasks = tasks
                    showEditIcon.toggle()
                } label: {
                    Text("순서 수정")
                        .underline()
                        .font(.ptRegular())
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            updateDetents()
        }
    }
    
    private func updateDetents() {
        // tasks의 개수에 따라 detents 값 조정
        let fraction = min(0.5 + 0.1 * max(0, Double(tasks.count - 2)), 0.9)
        detents = [.fraction(fraction)]
    }
}

struct DropViewDelegate: DropDelegate {
    let item: TaskList
    @Binding var items: [TaskList]
    @Binding var draggedItem: TaskList?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem.id != item.id,
              let fromIndex = items.firstIndex(where: { $0.id == draggedItem.id }),
              let toIndex = items.firstIndex(where: { $0.id == item.id }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}

#Preview {
    @Previewable @State var sampleTasks: [TaskList] = [
        TaskList(title: "운동하기", emoji: "💪", timer: 180),
        TaskList(title: "책 읽기", emoji: "📖", timer: 600)
    ]

    @Previewable @State var sampleDetents: Set<PresentationDetent> = [.fraction(0.5)]
    
    TaskListSheet(tasks: $sampleTasks, detents: $sampleDetents)
}
