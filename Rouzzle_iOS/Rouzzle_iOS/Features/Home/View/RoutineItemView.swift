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
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Image(.completedRoutine)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(370 / 137, contentMode: .fit)
                
                HStack {
                    Text(routine.emoji)
                        .font(.ptBold(.title2))
                        .padding(.trailing, 10)
                        .padding(.bottom, 7)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(routine.title)
                            .font(.ptSemiBold())
                            .foregroundStyle(.black)
                            .bold()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        HStack(spacing: 5) {
                            Image(systemName: "bell")
                        }
                        Text(convertDaysToString(days: routine.dayStartTime.keys.sorted()))
                            .font(.caption)
                    }
                    .foregroundStyle(Color.subHeadlineFontColor)
                }
                .padding(.horizontal, 20)
                .offset(y: -7)
            }
            .padding(.horizontal)
        }
    }
}
