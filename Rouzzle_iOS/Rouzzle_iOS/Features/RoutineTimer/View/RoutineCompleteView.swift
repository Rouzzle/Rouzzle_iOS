//
//  RoutineCompleteView.swift
//  Rouzzle_iOS
//
//  Created by Hyojeong on 3/18/25.
//

import SwiftUI

struct RoutineCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: RoutineTimerViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            // MARK: - 루틴 이름 박스
            Text(viewModel.routineTitle)
                .font(.ptBold(.title))
                .padding(.top, 60)
            
            // MARK: - 루틴 시작 및 완료 시간
            Text(viewModel.routineTimeRange)
                .font(.ptRegular())
                .foregroundStyle(.rz747272)
                .padding(.top)
            
            // MARK: - 연속일, 누적일 박스
            HStack {
                VStack(spacing: 6) {
                    Text("\(viewModel.longestDays)")
                        .font(.ptBold(.title))
                    
                    Text("연속일")
                        .font(.ptRegular())
                        .foregroundStyle(.rz747272)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 60)
                
                VStack(spacing: 6) {
                    Text("\(viewModel.totalDays)")
                        .font(.ptBold(.title))
                    
                    Text("누적일")
                        .font(.ptRegular())
                        .foregroundStyle(.rz747272)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 113)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.RZFAFAFA)
            )
            .padding(.top, 39)
            .padding(.horizontal, 46)
            
            // MARK: - 완료한 할 일 리스트
            ScrollView {
                VStack(spacing: 18) {
                    ForEach(viewModel.completedTasks, id: \.id) { task in
                        HStack(spacing: 18) {
                            Text(task.emoji)
                                .font(.largeTitle)
                            
                            Text(task.title)
                                .font(.ptSemiBold())
                            
                            Spacer()
                            
                            if let elapsed = task.elapsedTime {
                                Text("\(elapsed)초")
                                    .font(.ptRegular())
                                    .foregroundStyle(.rz747272)
                            } else {
                                Text("\(task.timer)분")
                                    .font(.ptRegular())
                                    .foregroundStyle(.rz747272)
                            }
                        }
                    }
                }
                .padding(.horizontal, 46)
            }
            .padding(.top, 51)
            
            RouzzleButton(buttonType: .complete) {
                path.removeLast(path.count)
            }
            .padding()
        }
    }
}

#Preview {
    RoutineCompleteView(viewModel: .init(routine: RoutineItem.sampleData[0]), path: .constant(NavigationPath()))
}
