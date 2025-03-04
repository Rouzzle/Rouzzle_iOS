//
//  RecommendedSet.swift
//  Rouzzle_iOS
//
//  Created by Hyeonjeong Sim on 3/4/25.
//

import SwiftUI

struct RecommendedSet: View {
    @Environment(\.dismiss) private var dismiss
    
    // 외부에서 주입받는 카테고리
    let category: TimeCategory
    
    // 선택된 태스크 목록
    @State private var selectedTasks: [RecommendTodoTask] = []
    
    // 전체 선택 상태
    @State private var allSelected: Bool = false
    
    // 태스크 선택 완료 후 실행될 액션
    var onSave: ([RecommendTodoTask]) -> Void = { _ in }
    
    init(category: TimeCategory, onSave: @escaping ([RecommendTodoTask]) -> Void = { _ in }) {
        self.category = category
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.RZFCFFF_0)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 10) {
                        // 카테고리 설명 헤더
                        Text(category.description)
                            .font(.ptBold(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                        
                        // 추천 태스크 목록
                        ForEach(0..<getTasksForCategory().count, id: \.self) { index in
                            let task = getTasksForCategory()[index]
                            
                            RecommendTask(
                                isPlus: Binding(
                                    get: { selectedTasks.contains(where: { $0.title == task.title }) },
                                    set: { isSelected in
                                        toggleTask(task.toRecommendTodoTask())
                                    }
                                ),
                                emojiTxt: task.emoji,
                                title: task.title,
                                timeInterval: "\(task.timer / 60)분",
                                description: task.description
                            ) {
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, index < getTasksForCategory().count - 1 ? 10 : 5)
                        }
                        
                        // 전체 선택 버튼
                        HStack(spacing: 4) {
                            Spacer()
                            HStack(spacing: 2) {
                                Image(systemName: allSelected ? "checkmark.square.fill" : "square")
                                    .foregroundStyle(allSelected ? Color.accent : Color.gray)
                                Text("전체선택")
                                    .font(.ptRegular(size: 12))
                                    .foregroundStyle(.gray)
                            }
                            .onTapGesture {
                                toggleAllTasks()
                            }
                        }
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        
                        RouzzleButton(buttonType: .addtoroutine) {
                            onSave(selectedTasks)
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 0)
                    .padding(.bottom, 30)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.ptSemiBold(size: 20))
                    }
                }
            }
            .navigationTitle("추천 세트")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // 현재 선택된 카테고리에 맞는 태스크 가져오기
    private func getTasksForCategory() -> [RecommendTaskWithDescription] {
        return RecommendTaskData.getRecommendedTasksWithDescription(for: category)
    }
    
    // 태스크 선택/해제 토글
    private func toggleTask(_ task: RecommendTodoTask) {
        if selectedTasks.contains(where: { $0.title == task.title }) {
            selectedTasks.removeAll(where: { $0.title == task.title })
        } else {
            selectedTasks.append(task)
        }
        
        // 전체 선택 상태 업데이트
        allSelected = selectedTasks.count == getTasksForCategory().count
    }
    
    // 모든 태스크 선택/해제 토글
    private func toggleAllTasks() {
        if allSelected {
            selectedTasks.removeAll()
            allSelected = false
        } else {
            selectedTasks = getTasksForCategory().map { $0.toRecommendTodoTask() }
            allSelected = true
        }
    }
}

// 시간대별 카테고리와 TimeCategory 간 변환 함수
extension RoutineCategoryByTime {
    func toTimeCategory() -> TimeCategory {
        switch self {
        case .morning: return .morning
        case .afternoon: return .afternoon
        case .evening: return .evening
        case .rest: return .night // rest는 night에 매핑
        }
    }
}


#Preview {
    RecommendedSet(category: .morning) { tasks in
        print("선택된 태스크: \(tasks.count)개")
    }
}
