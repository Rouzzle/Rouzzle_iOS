//
//  RecommendTaskView.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 4/2/25.
//

import SwiftUI

struct RecommendTaskView: View {
    let task: RoutineTask
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))

            HStack(spacing: 10) {
                // Emoji + Task info
                HStack {
                    Text(task.emoji)
                        .font(.title)
                        .frame(width: 40)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("\(task.timer.formattedTimer)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                // 선택 버튼
                Button(action: onTap) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .accentColor : .gray)
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
