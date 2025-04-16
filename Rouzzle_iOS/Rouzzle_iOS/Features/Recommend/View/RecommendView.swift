//
//  RecommendView.swift
//  Rouzzle_iOS
//
//  Created by Hyeonjeong Sim on 4/10/25.
//

import SwiftUI

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
                addRoutine: { title, emoji, routine in
                    guard let newRoutine = routine else { return }
                    newRoutine.title = title
                    newRoutine.emoji = emoji
                    Task {
                        await viewModel.addTask(newRoutine)
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
