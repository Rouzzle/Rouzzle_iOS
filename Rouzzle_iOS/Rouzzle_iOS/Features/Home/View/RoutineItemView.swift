//
//  RoutineItemView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/24/25.
//

import Foundation
import SwiftUI

struct RoutineItemView: View {
    let routine: RoutineItem
    let onTap: () -> Void
    
    // 오늘의 시작 시간 문자열 (예: "오전 9:00")
    var todayStartTime: String {
        let today = Date()
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: today)
        let value = routine.dayStartTime[weekdayNumber] ?? routine.dayStartTime.first?.value ?? ""
        return value.to12HourPeriod() + " " + value.to12HourFormattedTime()
    }
    
    // 진행 중인 작업 수 / 전체 작업 수, 완료된 경우에는 빈 문자열
    var inProgressStr: String {
        let completedTaskCount = routine.taskList.filter { $0.isCompleted }.count
        if completedTaskCount == 0 {
            return ""
        }
        return "\(completedTaskCount)/\(routine.taskList.count)"
    }
    
    // 알림 아이콘: alarmIDs가 존재하면 "bell", 없으면 "bell.slash"
    var alarmImageName: String {
        if let alarmIDs = routine.alarmIDs, !alarmIDs.isEmpty {
            return "bell"
        } else {
            return "bell.slash"
        }
    }
    
    // 배경 이미지: 루틴이 완료되었으면 완료 이미지, 아니면 진행 이미지 사용
    var backgroundImage: Image {
        routine.isCompleted ? Image(.completedRoutine) : Image(.pendingRoutine)
    }
    
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                backgroundImage
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(370 / 137, contentMode: .fit)
                
                HStack {
                    // 이모지 및 제목 영역
                    Text(routine.emoji)
                        .font(.ptBold(.title2))
                        .padding(.trailing, 10)
                        .padding(.bottom, 7)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(routine.title)
                            .font(.ptSemiBold())
                            .foregroundStyle(.black)
                            .bold()
                            .strikethrough(routine.isCompleted)
                        
                        if !inProgressStr.isEmpty {
                            Text(inProgressStr)
                                .font(.ptRegular())
                                .foregroundStyle(Color.subHeadlineFontColor)
                        }
                    }
                    
                    Spacer()
                    
                    // 오른쪽 영역: 알림, 시작 시간, 요일 표시
                    VStack(alignment: .trailing, spacing: 5) {
                        HStack(spacing: 5) {
                            Image(systemName: alarmImageName)
                            Text(todayStartTime)
                        }
                        .font(.ptRegular())
                        
                        Text(convertDaysToString(days: routine.dayStartTime.keys.sorted()))
                            .font(.ptRegular())
                    }
                    .foregroundStyle(Color.subHeadlineFontColor)
                }
                .padding(.horizontal, 20)
                .offset(y: -7)
            }
            .padding(.horizontal)
        }
        .opacity(routine.isCompleted ? 0.6 : 1)
    }
}
