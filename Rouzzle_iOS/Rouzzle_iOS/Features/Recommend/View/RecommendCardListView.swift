//
//  RecommendCardListView.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 4/2/25.
// 추천 루틴 리스트를 보여주는 view

import SwiftUI

struct RecommendCardListView: View {
    @Binding var cards: [Card]
    @Binding var selectedRecommendTask: [RecommendTodoTask]
    @Binding var allCheckBtn: Bool

    @State private var selectedCardID: UUID?
    @State private var showingRoutineSheet = false

    let addRoutine: (String, String, RoutineItem?) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(cards) { card in
                        Group {
                            if selectedCardID == card.id {
                                // 펼쳐진 카드
                                expandedCard(card)
                                    .id("\(card.id)-expanded")
                            } else {
                                // 접힌 카드
                                collapsedCard(card)
                                    .id("\(card.id)-collapsed")
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: selectedCardID)
                    }
                }
                .padding(.top, 2)
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .onChange(of: selectedCardID) { _, _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    allCheckBtn = false
                    selectedRecommendTask.removeAll()

                    if let selectedID = selectedCardID {
                        proxy.scrollTo("\(selectedID)-expanded", anchor: .top)
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .didTapCollapseCard)) { _ in
                withAnimation {
                    selectedCardID = nil
                }
            }
        }
    }

    // 펼쳐진 카드
    private func collapsedCard(_ card: Card) -> some View {
        VStack {
            HStack(spacing: 16) {
                Text(card.imageName)
                    .font(.system(size: 35))
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 6) {
                    if let subTitle = card.subTitle {
                        Text(subTitle)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.green.opacity(0.2)))
                    }

                    Text(card.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(selectedCardID == card.id ? 180 : 0))
            }
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        .onTapGesture {
            withAnimation {
                selectedCardID = card.id
            }
        }
    }

    // 접힌 카드
    private func expandedCard(_ card: Card) -> some View {
        RecommendExpandedCardView(
            card: card,
            selectedRecommendTask: $selectedRecommendTask,
            allCheckBtn: $allCheckBtn,
            showingRoutineSheet: $showingRoutineSheet,
            addRoutine: addRoutine
        )
    }
}
