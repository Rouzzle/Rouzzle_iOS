//
//  TaskStatusPuzzle.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/18/25.
//

import SwiftUI

enum TaskStatus {
    case pending
    case inProgress
    case completed
    
    var image: Image {
        switch self {
        case .pending:
            Image(.pendingTask)
        case .inProgress:
            Image(.inProgressTask)
        case .completed:
            Image(.completedTask)
        }
    }
}

struct TaskStatusPuzzle: View {
    @Bindable var task: TaskList
    
    var taskStatus: TaskStatus {
        task.isCompleted ? .completed : .pending
    }
    
    var body: some View {
        HStack {
            Text(task.emoji)
                .font(.ptBold(size: 40))
                .padding(.leading, 25)
            
            HStack(spacing: 10) {
                Text(task.title)
                    .font(.ptMedium())
                    .strikethrough(taskStatus == .completed)
                    .lineLimit(1)
            }
            .padding(.horizontal, 7)
            
            Spacer()
            
            Text(task.timer.formattedTimer)
                .font(.ptRegular())
                .foregroundColor(Color.subHeadlineFontColor)
                .padding(.trailing, 25)
        }
        .padding(.vertical, 8)
        .background {
            if taskStatus == .completed {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.secondary)
                    .opacity(0.5)
            }
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundStyle(.secondary)
        }
        .opacity(taskStatus == .completed ? 0.5 : 1)
    }
}

struct TaskStatusRow: View {
    private(set) var taskStatus: TaskStatus
    private(set) var emojiText: String = "💊"
    private(set) var title: String = "유산균 먹기"
    private(set) var timeInterval: Int?
    
    @Binding var showEditIcon: Bool // 리스트 수정일 때 보이는 아이콘
    @Binding var showDeleteIcon: Bool // 리스트 삭제할 때 보이는 버튼
    
    var onDelete: (() -> Void)? // 삭제 클로저
    
    @State private var showDeleteConfirmation = false
    
    private var backgroundColor: Color {
        switch taskStatus {
        case .completed:
            return Color.fromRGB(r: 248, g: 247, b: 247)
        case .inProgress:
            return Color.fromRGB(r: 252, g: 255, b: 240)
        case .pending:
            return .white
        }
    }
    
    var body: some View {
        HStack {
            Text(emojiText)
                .font(.system(size: 40))
                .padding(.horizontal, 8)
            
            Text(title)
                .font(.ptMedium())
                .strikethrough(taskStatus == .completed)
                .padding(.trailing, 12)
            
            Spacer()
            
            if let timeInterval = timeInterval {
                Text(timeInterval >= 60 ? "\(timeInterval / 60)분" : "\(timeInterval)초")
                    .font(.ptRegular())
                    .foregroundStyle(Color.subHeadlineFontColor)
            } else {
                Text("지속 시간 없음")
                    .font(.ptRegular())
                    .foregroundStyle(Color.subHeadlineFontColor)
            }
            
            if showEditIcon {
                Image(.listEditIcon)
                    .foregroundStyle(Color.subHeadlineFontColor)
                    .padding(.leading, 10)
            }
            
            // 삭제하기 버튼
            if showDeleteIcon {
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.red)
                        .padding(.leading, 10)
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("삭제하시겠습니까?"),
                        message: Text("이 작업은 되돌릴 수 없습니다."),
                        primaryButton: .destructive(Text("삭제")) {
                            onDelete?()
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            }
        }
        .opacity(taskStatus == .completed ? 0.5 : 1.0)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .stroke(
                    taskStatus == .inProgress ? Color.themeColor.opacity(0.3) : .rzd9D9D9, // inProgress일 때만 테두리
                    lineWidth: 1
                )
        )
    }
}

struct TaskRecommendPuzzle: View {
    var recommendTask: RecommendTodoTask
    var onAddTap: () -> Void
    var body: some View {
        HStack {
            Text(recommendTask.emoji)
                .font(.system(size: 40))
                .padding(.leading, 25)
            
            HStack(spacing: 10) {
                Text(recommendTask.title)
                    .font(.ptMedium())
                    .lineLimit(1)
                
                Text(recommendTask.timer.formattedTimer)
                    .font(.ptRegular())
                    .foregroundColor(Color.subHeadlineFontColor)
                
            }
            .padding(.horizontal, 7)
            
            Spacer()
            
            Button {
                onAddTap()
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(Color.subHeadlineFontColor)
                    .font(.title2)
                    .padding(.trailing, 25)
                
            }
        }
        .padding(.vertical, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6, 3]))
                .foregroundStyle(.rzd9D9D9)
        )
        
    }
}
