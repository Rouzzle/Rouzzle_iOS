//
//  RecommendCategoryView.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 4/2/25.
//

import SwiftUI

struct RecommendCategoryView: View {
    @Binding var selectedCategory: RecommendViewModel.Category
    private let categories = RecommendViewModel.Category.allCases

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = selectedCategory == category

                    Text(category.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .accentColor : .gray)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isSelected ? Color.green.opacity(0.15) : Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .onTapGesture {
                            selectedCategory = category
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
    }
}

#Preview {
    RecommendCategoryView(selectedCategory: .constant(.celebrity))
}
