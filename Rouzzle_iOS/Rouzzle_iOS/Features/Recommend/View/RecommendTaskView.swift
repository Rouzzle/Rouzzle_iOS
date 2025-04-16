//
//  RecommendTaskView.swift
//  Rouzzle_iOS
//
//  Created by Hyeonjeong Sim on 4/10/25.
//

import SwiftUI

struct RecommendTaskView: View {
    let task: RoutineTask
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.RZFAFAFA))
            
            HStack(spacing: 10) {
                HStack {
                    Text(task.emoji)
                        .font(.title)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.ptSemiBold(size: 14))
                            .foregroundStyle(.rz1F1F1F)
                        
                        Text("\(task.timer.formattedTimer)")
                            .font(.ptRegular(size: 12))
                            .foregroundStyle(.rz999999)
                    }
                }
                
                Spacer()
                
                // 선택 버튼
                Button(action: onTap) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .accentColor : .rzd9D9D9)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
    }
}

#Preview {
    RecommendTaskView(
        task: RoutineTask(title: "아침 스트레칭", emoji: "🙆‍♀️", timer: 15),
        isSelected: false,
        onTap: {}
    )
}
