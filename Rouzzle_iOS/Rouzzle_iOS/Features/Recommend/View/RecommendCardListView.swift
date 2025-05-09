//
//  RecommendCardListView.swift
//  Rouzzle_iOS
//
//  Created by Hyeonjeong Sim on 4/10/25.
//

import SwiftUI
import SwiftData

struct RecommendCardListView: View {
    @Binding var cards: [Card]
    @Binding var selectedRecommendTask: [RecommendTodoTask]
    @Binding var isAllSelected: Bool
    @State private var selectedCardID: UUID?
    @State private var showingRoutineSheet = false
    
    @Query private var routines: [RoutineItem]
    
    let addRoutine: (String, String, RoutineItem?) -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(cards) { card in
                        Group {
                            if selectedCardID == card.id {
                                expandedCard(card)
                                    .id("\(card.id)-expanded")
                            } else {
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
            .scrollIndicators(.hidden)
            .onChange(of: selectedCardID) { _, _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isAllSelected = false
                    selectedRecommendTask.removeAll()
                    
                    if let selectedID = selectedCardID {
                        proxy.scrollTo("\(selectedID)-expanded", anchor: .top)
                    }
                }
            }
        }
    }
    
    private func cardContainer<Content: View>(_ content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.rze1E1E1, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
    }
    
    private func collapsedCard(_ card: Card) -> some View {
        cardContainer(
            HStack(spacing: 16) {
                Text(card.imageName)
                    .font(.system(size: 35))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 6) {
                    if let subTitle = card.subTitle {
                        Text(subTitle)
                            .font(.ptMedium(size: 11))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .frame(height: 16)
                            .background(
                                Capsule()
                                    .fill(Color.themeColor)
                            )
                            .padding(.top, 5)
                    }
                    
                    Text(card.title)
                        .font(.ptBold(size: 16))
                        .foregroundStyle(.rz1F1F1F)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(.rzc1C1C1)
                    .font(.system(size: 20, weight: .regular))
                    .padding(.trailing, 8)
                    .rotationEffect(.degrees(selectedCardID == card.id ? 180 : 0))
            }
                .padding(.vertical, 12)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedCardID = card.id
            }
        }
    }
    
    private func expandedCard(_ card: Card) -> some View {
        cardContainer(
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Text(card.imageName)
                        .font(.system(size: 35))
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        if let subTitle = card.subTitle {
                            Text(subTitle)
                                .font(.ptMedium(size: 11))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .frame(height: 16)
                                .background(
                                    Capsule()
                                        .fill(Color.themeColor)
                                )
                                .padding(.top, 5)
                        }
                        
                        Text(card.title)
                            .font(.ptBold(size: 16))
                            .foregroundStyle(Color.subBlack)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.up")
                        .foregroundStyle(.rzc1C1C1)
                        .font(.system(size: 20, weight: .regular))
                        .padding(.trailing, 8)
                }
                .padding(.vertical, 12)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedCardID = nil
                    }
                }
                
                Text(card.fullText)
                    .font(.ptLight(size: 16))
                    .foregroundStyle(.rz3B3D4A)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                HStack {
                    Spacer()
                    Button(action: {
                        toggleAllSelection(for: card)
                    }, label: {
                        HStack(spacing: 2) {
                            Image(systemName: isAllSelected ? "checkmark.square" : "square")
                            Text("전체선택")
                                .font(.ptRegular(size: 12))
                        }
                        .foregroundStyle(isAllSelected ? .rz999999 : .gray)
                    })
                }
                .padding(.vertical, 12)
                
                VStack(spacing: 8) {
                    ForEach(card.routines, id: \.title) { task in
                        RecommendTaskView(
                            task: task,
                            isSelected: isTaskSelected(task),
                            onTap: {
                                toggleTaskSelection(task, in: card)
                            }
                        )
                    }
                }
                .padding(.vertical, 8)
                
                RouzzleButton(
                    buttonType: .addtoroutine,
                    disabled: selectedRecommendTask.isEmpty,
                    action: {
                        showingRoutineSheet = true
                    }
                )
                .padding(.vertical)
            }
        )
        .sheet(isPresented: $showingRoutineSheet) {
            RecommendSheet(tasks: selectedRecommendTask, routines: routines) { routine in
                addRoutine("", "", routine)
            }
            .presentationDetents([.fraction(0.3)])
            .interactiveDismissDisabled()
        }
    }
    
    private func isTaskSelected(_ task: Any) -> Bool {
        let taskMirror = Mirror(reflecting: task)
        
        guard let titleProp = taskMirror.children.first(where: { $0.label == "title" }),
              let title = titleProp.value as? String else {
            return false
        }
        
        return selectedRecommendTask.contains { $0.title == title }
    }
    
    private func toggleTaskSelection(_ task: Any, in card: Card) {
        let taskMirror = Mirror(reflecting: task)
        
        guard let titleProp = taskMirror.children.first(where: { $0.label == "title" }),
              let title = titleProp.value as? String,
              let emojiProp = taskMirror.children.first(where: { $0.label == "emoji" }),
              let emoji = emojiProp.value as? String,
              let timerProp = taskMirror.children.first(where: { $0.label == "timer" }),
              let timer = timerProp.value as? Int else {
            return
        }
        
        let recommendTask = RecommendTodoTask(emoji: emoji, title: title, timer: timer)
        
        if selectedRecommendTask.contains(where: { $0.title == title }) {
            selectedRecommendTask.removeAll { $0.title == title }
        } else {
            selectedRecommendTask.append(recommendTask)
        }
        
        isAllSelected = selectedRecommendTask.count == card.routines.count
    }
    
    private func toggleAllSelection(for card: Card) {
        if isAllSelected {
            isAllSelected = false
            selectedRecommendTask.removeAll()
        } else {
            isAllSelected = true
            selectedRecommendTask = card.routines.compactMap { task in
                let taskMirror = Mirror(reflecting: task)
                
                guard let titleProp = taskMirror.children.first(where: { $0.label == "title" }),
                      let title = titleProp.value as? String,
                      let emojiProp = taskMirror.children.first(where: { $0.label == "emoji" }),
                      let emoji = emojiProp.value as? String,
                      let timerProp = taskMirror.children.first(where: { $0.label == "timer" }),
                      let timer = timerProp.value as? Int else {
                    return nil
                }
                
                return RecommendTodoTask(emoji: emoji, title: title, timer: timer)
            }
        }
    }
}
