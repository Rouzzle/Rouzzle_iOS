//
//  RoutineTimerView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/25/25.
//

import SwiftUI

struct RoutineTimerView: View {
    @State var viewModel: RoutineTimerViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isShowingTaskListSheet: Bool = false
    // 나가기 -> 알럿 (알림재설정 or 그대로 나가기)
    @State private var showExitAlert: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.5)]
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack(alignment: .top) {
            // 그라데이션 배경
            LinearGradient(
                colors: viewModel.timerState.gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .transition(.opacity)
            .ignoresSafeArea()
            
            VStack {
                // MARK: - X 버튼
                Button {
                    showExitAlert = true
                    //dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                // MARK: - 할일 이름
                if let inProgressTask = viewModel.inProgressTask {
                    Text("\(inProgressTask.emoji) \(inProgressTask.title)")
                        .font(.ptBold(size: 24))
                        .padding(.top, 20)
                }
                
                // MARK: - 퍼즐 모양 타이머
                ZStack {
                    Image(.puzzleTimer)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(viewModel.timerState.puzzleTimerColor)
                    
                    VStack {
                        if viewModel.inProgressTask?.timer != nil { // 시간 있는 할일
                            if viewModel.timeRemaining >= 0 {
                                Text(viewModel.timeRemaining.toTimeString())
                                    .font(.ptBold(size: 66))
                                    .foregroundStyle(.white)
                            } else { // 할일 시간 초과
                                Text("+\(abs(viewModel.timeRemaining).toTimeString())")
                                    .font(.ptBold(size: 66))
                                    .foregroundStyle(viewModel.timerState == .paused ? .white : .overtimeText)
                            }
                        } else { // 시간 없는 할일
                            Text("Check!")
                                .font(.ptBold(size: 66))
                                .foregroundStyle(.white)
                        }
                        
                        if let timerValue = viewModel.inProgressTask?.timer {
                            let minutes = timerValue / 60
                            let seconds = timerValue % 60
                            Text(minutes > 0 ? "\(minutes)분" : "\(seconds)초")
                                .font(.ptRegular())
                                .foregroundStyle(viewModel.timerState.timeTextColor)
                        } else {
                            Text("")
                        }
                    }
                }
                .padding(.top, 30)
                
                // MARK: - 버튼 3개(일시정지, 체크, 건너뛰기)
                HStack(spacing: 14) {
                    // 일시정지
                    Button {
                        viewModel.toggleTimer()
                    } label: {
                        Image(viewModel.timerState == .paused ? .playIcon : .pauseIcon)
                    }
                    .disabled(viewModel.inProgressTask?.timer == nil)
                    
                    // 완료 체크
                    Button {
                        viewModel.markTaskAsCompleted()
                    } label: {
                        Image(.checkIcon)
                    }
                    
                    // 건너뛰기
                    Button {
                        viewModel.skipTask()
                    } label: {
                        Image(.skipIcon)
                    }
                }
                .padding(.top, 30)
                
                // MARK: - 다음 할일
                Text("다음 할일")
                    .font(.ptSemiBold(.callout))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                
                if let nextTask = viewModel.nextPendingTask {
                    TaskStatusRow(
                        taskStatus: .pending,
                        emojiText: nextTask.emoji,
                        title: nextTask.title,
                        timeInterval: nextTask.timer,
                        showEditIcon: .constant(false),
                        showDeleteIcon: .constant(false)
                    )
                    .padding(.top, 18)
                }
                
                Spacer()
                
                // MARK: - 할일 전체 보기
                Button {
                    isShowingTaskListSheet.toggle()
                } label: {
                    Text("할일 전체 보기")
                        .underline()
                        .font(.ptRegular())
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
        }
        .animation(.smooth, value: viewModel.timerState)
        .sheet(isPresented: $isShowingTaskListSheet) {
            TaskListSheet(
                tasks: $viewModel.viewTasks,
                detents: $detents,
                inProgressTask: viewModel.inProgressTask
            )
            .presentationDetents(detents)
        }
        .fullScreenCover(isPresented: $viewModel.routineCompleted) {
            RoutineCompleteView(
                viewModel: RoutineCompleteViewModel(
                    routine: viewModel.routineItem,
                    startTime: viewModel.routineTakeTime.0,
                    endTime: viewModel.routineTakeTime.1),
                path: $path
            )
        }
        .onAppear {
            viewModel.resetTask()
            viewModel.initializeCurrentTaskIndex()
            viewModel.startTimer()
        }
        .alert("루틴을 종료하시겠어요?", isPresented: $showExitAlert) {
            Button("나가기", role: .destructive) {
                dismiss()
            }
            Button("취소", role: .cancel) { }
        }
    }
}

#Preview {
    RoutineTimerView(viewModel: .init(routine: RoutineItem.sampleData[0]),
                     path: .constant(NavigationPath()))
}
