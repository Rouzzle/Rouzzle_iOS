//
//  RecommendCategoryView.swift
//  Rouzzle_iOS
//
//  Created by Hyeonjeong Sim on 4/10/25.
//

import SwiftUI

struct RecommendCategoryView: View {
    @Binding var selectedCategory: RecommendViewModel.Category
    private let categories = RecommendViewModel.Category.allCases
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
    }
    
    private struct CategoryButton: View {
        let category: RecommendViewModel.Category
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Text(category.rawValue)
                .font(.ptSemiBold(size: 16))
                .foregroundStyle(isSelected ? .rz558A24 : .rzc9C9C9)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.rzfcfff0 : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.rz558A24 : Color.rzc9C9C9, lineWidth: 1)
                )
                .onTapGesture(perform: action)
        }
    }
}

#Preview {
    RecommendCategoryView(selectedCategory: .constant(.celebrity))
}
