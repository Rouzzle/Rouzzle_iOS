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
    @Injected(\.swiftDataService) private var swiftDataService: SwiftDataServiceProtocol
    @Bindable var viewModel: AddRoutineViewModel
    @State private var showTimerView = false
    @State private var isShowingRoutineSettingsSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
    @State private var isShowingEditRoutineSheet: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Label(routine.todayStartTimeFormatted, systemImage: "clock")
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
                if routine.taskList.isEmpty {
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
                    ForEach(routine.taskList) { task in
                        TaskStatusPuzzle(task: task)
                    }
                }
                
                RouzzleButton(buttonType: .timerStart, disabled: routine.taskList.isEmpty) {
                    showTimerView.toggle()
                    
                    NotificationManager.shared.cancelTodayAlarms(for: routine)
                }
                .padding(.top)
                
                HStack {
                    Text("추천 할 일")
                        .font(.ptBold(size: 18))
                    
                    Spacer()
                    
                    Button {
                        viewModel.getRecommendTask()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                    }
                }
                .padding(.top, 30)
                // 추천 리스트
                if viewModel.recommendTodoTask.isEmpty {
                    Text("추천 할 일을 모두 등록했습니다!")
                        .font(.ptRegular())
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    VStack(spacing: 10) {
                        ForEach(viewModel.recommendTodoTask, id: \.self) { recommend in
                            TaskRecommendPuzzle(recommendTask: recommend) {
                                viewModel.getRecommendTask()
                                viewModel.addTask(from: recommend, to: routine)
                            }
                        }
                    }
                    // .animation(.smooth, value: //routineStore.recommendTodoTask)
                }
            }
        }
        .customNavigationBar(title: "\(routine.emoji) \(routine.title)")
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
        .customAlert(
            isPresented: $isShowingDeleteAlert,
            title: "해당 루틴을 삭제합니다",
            message: "삭제 버튼 선택 시, 루틴 데이터는\n삭제되며 복구되지 않습니다.",
            primaryButtonTitle: "삭제",
            primaryAction: {
                do {
                    try swiftDataService.deleteRoutine(routine)
                    dismiss()
                } catch {
                    print("루틴 삭제 실패: \(error.localizedDescription)")
                }
            }
        )
        .fullScreenCover(isPresented: $showTimerView) {
            // TODO: - 모두 완료되어 있을때 완료 상태를 초기화 해야한다. 아이템 완료상태 초기화 해서 보냄
            RoutineTimerView(viewModel: RoutineTimerViewModel(routine: routine), path: $path)
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

#Preview {
    NavigationStack {
        TaskListView(routine: RoutineItem.sampleData[0], path: .constant(NavigationPath()), viewModel: AddRoutineViewModel())
    }
}
