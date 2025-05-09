//
//  RecommendView.swift
//  Rouzzle_iOS
//
//  Created by Hyeonjeong Sim on 4/10/25.
//

import SwiftUI
import SwiftData

struct RecommendView: View {
    @State private var viewModel = RecommendViewModel()
    @State private var allCheckBtn = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("추천")
                    .font(.ptSemiBold(size: 18))
                    .padding(.leading)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            RecommendCategoryView(selectedCategory: $viewModel.selectedCategory)
                .padding(.bottom, 25)
            
            RecommendCardListView(
                cards: $viewModel.filteredCards,
                selectedRecommendTask: $viewModel.selectedRecommend,
                isAllSelected: $allCheckBtn,
                addRoutine: { _, _, routine in
                    guard let selectedRoutine = routine else { return }
                    
                    for task in viewModel.selectedRecommend {
                        if !selectedRoutine.taskList.contains(where: { $0.title == task.title }) {
                            let newTask = task.toTaskList()
                            selectedRoutine.taskList.append(newTask)
                        }
                    }
                    
                    Task {
                        await viewModel.addTask(selectedRoutine)
                    }
                }
            )
            Spacer()
        }
    }
}

#Preview {
    RecommendView()
}
