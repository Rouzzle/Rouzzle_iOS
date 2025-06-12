//
//  RoutineMonthSelectorView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI

struct RoutineMonthSelectorView: View {
    @Binding var month: Date
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.basic)
                }
                
                Text(month.formattedCalenderDate)
                    .padding(.horizontal, 6)
                
                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.basic)
                }
            }
        }
        .padding()
    }
    
    private func changeMonth(by value: Int) {
        self.month = Calendar.current.date(byAdding: .month, value: value, to: month) ?? month
    }
}