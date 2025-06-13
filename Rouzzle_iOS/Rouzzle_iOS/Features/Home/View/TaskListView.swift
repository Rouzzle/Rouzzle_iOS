//
//  TaskListView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 3/11/25.
//

import SwiftUI
import Factory
// TODO: - 루틴 삭제하기 뻑남, 루틴 수정하기 빈 화면

struct TaskListView: View {
    let routine: RoutineItem
    @Binding var path: NavigationPath
    @StateObject var viewModel: TaskListViewModel
    @State private var showTimerView = false
    @State private var isShowingRoutineSettingsSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
    @State private var isShowingEditRoutineSheet: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    
    init(routine: RoutineItem, path: Binding<NavigationPath>) {
        self.routine = routine
        self._path = path
        _viewModel = StateObject(wrappedValue: TaskListViewModel(routineItem: routine))
    }
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Label(viewModel.routineItem.todayStartTimeFormatted, systemImage: "clock")
                        .font(.ptMedium())
                        .foregroundStyle(Color.subHeadlineFontColor)
                        .padding(.top)
                    
                    Spacer()
                    
                    Button {
                        //isShowingAddTaskSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                }
                .padding(.bottom, 5)
                if viewModel.routineItem.taskList.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("할 일을 추가해보세요!")
                                .font(.title2)
                                .foregroundColor(.gray.opacity(0.5))
                                .font(.subheadline)
                            Image(systemName: "plus.circle")
                                .foregroundColor(.gray.opacity(0.5))
                                .font(.system(size: 28))
                            
                        }
                        .padding(.vertical, 50)
                        Spacer()
                    }
                    .onTapGesture {
                        //  isShowingAddTaskSheet.toggle()
                    }
                }
                else {
                    ForEach(viewModel.routineItem.taskList) { task in
                        TaskStatusPuzzle(task: task)
                    }
                }
                
                RouzzleButton(buttonType: .timerStart, disabled: viewModel.routineItem.taskList.isEmpty) {
                    showTimerView.toggle()
                    
                    NotificationManager.shared.cancelTodayAlarms(for: viewModel.routineItem)
                }
                .padding(.top)

                // 추천 리스트
                RecommendTaskListView(recommendTask: $viewModel.recommendTodoTask) {
                    viewModel.getRecommendTask()
                } taskAppend: { routineTask in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if let index = viewModel.routineTask.firstIndex(where: { $0.hashValue == routineTask.hashValue }) {
                            viewModel.routineTask.remove(at: index)
                        } else {
                            viewModel.routineTask.append(routineTask)
                            viewModel.saveRoutineTasks(task: routineTask)
                        }
                    }
                }
            }
        }
        .customNavigationBar(title: "\(viewModel.routineItem.emoji) \(viewModel.routineItem.title)")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingRoutineSettingsSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.ptSemiBold(size: 20))
                }
            }
        }
        .sheet(isPresented: $isShowingRoutineSettingsSheet) {
            RoutineSettingsSheet(
                isShowingEditRoutineSheet: $isShowingEditRoutineSheet,
                isShowingDeleteAlert: $isShowingDeleteAlert
            )
            .presentationDetents([.fraction(0.25)])
        }
        .onAppear {
            viewModel.getRecommendTask()
        }
        .customAlert(
            isPresented: $isShowingDeleteAlert,
            title: "해당 루틴을 삭제합니다",
            message: "삭제 버튼 선택 시, 루틴 데이터는\n삭제되며 복구되지 않습니다.",
            primaryButtonTitle: "삭제",
            primaryAction: {
                viewModel.deleteRoutine()
                dismiss()
            }
        )
        .fullScreenCover(isPresented: $showTimerView) {
            // TODO: - 모두 완료되어 있을때 완료 상태를 초기화 해야한다. 아이템 완료상태 초기화 해서 보냄
            RoutineTimerView(viewModel: RoutineTimerViewModel(routine: viewModel.routineItem), path: $path)
        }
        .fullScreenCover(isPresented: $isShowingEditRoutineSheet) {
        
//            EditRoutineView(viewModel: EditRoutineViewModel(routine: routineStore.selectedRoutineItem!)) { _ in
//                routineStore.loadState = .completed
//                routineStore.toastMessage = "수정에 성공했습니다."
//                routineStore.fetchViewTask()
//            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        TaskListView(routine: RoutineItem.sampleData[0], path: .constant(NavigationPath()), viewModel: AddRoutineViewModel())
//    }
//}
