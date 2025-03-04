//
//  RoutineTimerView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/25/25.
//

import SwiftUI

struct RoutineTimerView: View {
    var routine: RoutineItem
    @State var viewModel: RoutineTimerViewModel = RoutineTimerViewModel()
    @Environment(\.dismiss) private var dismiss
    
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
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                // MARK: - 루틴 이름
                Text("💊 유산균 먹기")
                    .font(.ptBold(size: 24))
                    .padding(.top, 20)
                
                // MARK: - 퍼즐 모양 타이머
                ZStack {
                    Image(.puzzleTimer)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(viewModel.timerState.puzzleTimerColor)
                    
                    VStack {
                        Text("04:39")
                            .font(.ptBold(size: 66))
                            .foregroundStyle(.white)
                        
                        Text("5분")
                            .font(.ptRegular())
                            .foregroundStyle(viewModel.timerState.timeTextColor)
                    }
                }
                .padding(.top, 30)
                
                // MARK: - 버튼 3개(일시정지, 체크, 건너뛰기)
                HStack(spacing: 14) {
                    // 일시정지
                    Button {
                        
                    } label: {
                        Image(viewModel.timerState == .paused ? .playIcon : .pauseIcon)
                    }
                    
                    // 완료 체크
                    Button {
                        
                    } label: {
                        Image(.checkIcon)
                    }
                    
                    // 건너뛰기
                    Button {
                        
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
                
                TaskStatusRow(
                    taskStatus: .pending,
                    emojiText: "🧼",
                    title: "설거지 하기",
                    timeInterval: 180,
                    showEditIcon: .constant(false),
                    showDeleteIcon: .constant(false)
                )
                .padding(.top, 18)
                
                Spacer()
                
                // MARK: - 할일 전체 보기
                Button {
                    
                } label: {
                    Text("할일 전체 보기")
                        .underline()
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
        }
        
        // 루틴 나열
//        ForEach(routine.taskList) { task in
//            Text(task.title)
//        }
    }
}

#Preview {
    RoutineTimerView(routine: RoutineItem.sampleData[0], viewModel: .init())
}
