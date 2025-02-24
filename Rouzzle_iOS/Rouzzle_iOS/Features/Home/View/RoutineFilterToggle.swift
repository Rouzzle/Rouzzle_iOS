//
//  RoutineFilterToggle.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/24/25.
//

import Foundation
import SwiftUI

struct RoutineFilterToggle: View {
    
    @Binding var isToday: Bool   // true면 Today, false면 All
    @Namespace private var toggleAnimation

    var body: some View {
        HStack(spacing: 0) {
            // Today 버튼
            Text("Today")
                .font(.ptSemiBold(size: 14))
                .frame(width: 40, height: 31)
                .padding(.horizontal, 8)
                .foregroundColor(isToday ? .accentColor : .gray)
                .background(
                    Group {
                        if isToday {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.white)
                                .padding(2)
                                .matchedGeometryEffect(id: "highlightitem", in: toggleAnimation)
                        }
                    }
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isToday = true
                    }
                }
            
            // All 버튼
            Text("All")
                .font(.ptSemiBold(size: 14))
                .frame(width: 40, height: 31)
                .padding(.horizontal, 8)
                .foregroundColor(isToday ? .gray : .accentColor)
                .background(
                    Group {
                        if !isToday {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.white)
                                .padding(2)
                                .matchedGeometryEffect(id: "highlightitem", in: toggleAnimation)
                        }
                    }
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isToday = false
                    }
                }
        }
        .padding(2)
        .frame(height: 35)
        .background(
            RoundedRectangle(cornerRadius: 23)
                .stroke(.white, lineWidth: 1)
                .background(Color.toggleGray)
                .clipShape(RoundedRectangle(cornerRadius: 23))
        )
    }
}
