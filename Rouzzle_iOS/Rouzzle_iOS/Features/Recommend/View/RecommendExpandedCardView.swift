////
////  RecommendExpandedCardView.swift
////  Rouzzle_iOS
////
////  Created by 이다영 on 4/2/25.
////
//
//import SwiftUI
//
//struct RecommendExpandedCardView: View {
//    let card: Card
//    @Binding var selectedRecommendTask: [RecommendTodoTask]
//    @Binding var allCheckBtn: Bool
//    @Binding var showingRoutineSheet: Bool
//    let addRoutine: (String, String, RoutineItem?) -> Void
//
//    var body: some View {
//        VStack(spacing: 0) {
//            cardHeader()
//            descriptionText()
//            selectAllButton()
//            taskListView()
//            routineAddButton()
//        }
//        .padding(.bottom)
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                .background(Color.white.cornerRadius(12))
//        )
//        .padding(.horizontal)
//        .sheet(isPresented: $showingRoutineSheet) {
//            RecommendSheet(
//                tasks: selectedRecommendTask,
//                routines: [],  // 필수: 비워두거나 상위에서 루틴 목록 받아서 넘겨도 OK
//                saveRoutine: { routine in
//                    addRoutine(card.title, card.imageName, routine)
//                }
//            )
//            .presentationDetents([.fraction(0.3)])
//            .presentationCornerRadius(20)
//        }
//    }
//
//    @ViewBuilder
//    // 이모지, 라벨, 이름, 화살표
//    private func cardHeader() -> some View {
//        HStack(spacing: 16) {
//            Text(card.imageName)
//                .font(.system(size: 35))
//                .frame(width: 40, height: 40)
//
//            VStack(alignment: .leading, spacing: 6) {
//                if let subTitle = card.subTitle {
//                    Text(subTitle)
//                        .font(.caption2)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 2)
//                        .background(Capsule().fill(Color.green.opacity(0.2)))
//                }
//
//                Text(card.title)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//                    .lineLimit(1)
//            }
//
//            Spacer()
//
//            Image(systemName: "chevron.up")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .onTapGesture {
//            NotificationCenter.default.post(name: .didTapCollapseCard, object: nil)
//        }
//    }
//
//    // 설명 텍스트
//    private func descriptionText() -> some View {
//        Text(card.fullText)
//            .font(.body)
//            .foregroundColor(.secondary)
//            .padding([.horizontal, .bottom])
//    }
//
//    // 전체선택 + 네모박스
//    private func selectAllButton() -> some View {
//        HStack {
//            Spacer()
//            Button(action: {
//                allCheckBtn.toggle()
//                if allCheckBtn {
//                    selectedRecommendTask = card.routines.map {
//                        RecommendTodoTask(emoji: $0.emoji, title: $0.title, timer: $0.timer)
//                    }
//                } else {
//                    selectedRecommendTask.removeAll()
//                }
//            }) {
//                HStack {
//                    Image(systemName: allCheckBtn ? "checkmark.square" : "square")
//                    Text("전체선택")
//                        .font(.subheadline)
//                }
//                .foregroundColor(allCheckBtn ? .primary : .gray)
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    // 각각의 루틴, +버튼, RecommendTaskView사용
//    private func taskListView() -> some View {
//        VStack(spacing: 8) {
//            ForEach(card.routines, id: \.title) { task in
//                RecommendTaskView(
//                    task: task,
//                    isSelected: selectedRecommendTask.contains(where: { $0.title == task.title }),
//                    onTap: {
//                        let newTask = RecommendTodoTask(emoji: task.emoji, title: task.title, timer: task.timer)
//                        if let index = selectedRecommendTask.firstIndex(where: { $0.title == task.title }) {
//                            selectedRecommendTask.remove(at: index)
//                        } else {
//                            selectedRecommendTask.append(newTask)
//                        }
//                        allCheckBtn = selectedRecommendTask.count == card.routines.count
//                    }
//                )
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    // 내 루틴에 저장하기 버튼 -> RecommendSheet열림
//    private func routineAddButton() -> some View {
//        RouzzleButton(
//            buttonType: .addtoroutine,
//            disabled: selectedRecommendTask.isEmpty,
//            action: {
//                showingRoutineSheet = true
//            }
//        )
//        .padding(.top)
//    }
//}
//
//// 카드 닫기 알림용 Notification 이름
//extension Notification.Name {
//    static let didTapCollapseCard = Notification.Name("didTapCollapseCard")
//}
