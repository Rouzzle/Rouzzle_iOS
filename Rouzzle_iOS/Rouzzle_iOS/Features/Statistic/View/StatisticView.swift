//
//  StatisticView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct StatisticView: View {
    @State private var month: Date = Date()
    @State private var selectedRoutine: String = "요약"
    let routines: [RoutineItem]
    var body: some View {
        VStack {
            Text("통계")
                .font(.ptSemiBold(.title2))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    SelectedRoutineButton(title: "요약", selected: selectedRoutine == "요약") {
                        selectedRoutine = "요약"
                    }
                    .padding(.leading)
                    
                    ForEach(routines, id: \.id) { routine in
                        let selected = routine.id.uuidString == selectedRoutine
                        SelectedRoutineButton(title: routine.title, selected: selected) {
                            selectedRoutine = routine.id.uuidString
                        }
                    }
                }
            }
            .padding(.bottom, 32)
            
            if(selectedRoutine == "요약") {
                //RoutineSummaryView(month: $month, routines: routines)
            } else {
                
            }
            
            
            Spacer()
        }
    }
}

struct RoutineSummaryView: View {
    
    @Binding var month: Date
    let routines: [RoutineItem]
    
    var body: some View {
        VStack {
            HStack {
                Text("월간 성공률")
                    .font(.ptBold())
                Spacer()
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
    func changeMonth(by value: Int) {
        self.month = Calendar.current.date(byAdding: .month, value: value, to: month) ?? month
    }

}

struct SelectedRoutineButton: View {
    private let title: String
    private let selected: Bool
    let action: () -> Void
    
    init(title: String, selected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.selected = selected
        self.action = action
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.ptSemiBold())
                .foregroundStyle(selected ? .accent : Color(uiColor: .systemGray))
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(selected ? .RZFCFFF_0 : .white)
                )
                .overlay(
                     RoundedRectangle(cornerRadius: 40)
                         .stroke(selected ? Color.accentColor : Color(uiColor: .systemGray), lineWidth: 1)
                 )
                 .clipShape(RoundedRectangle(cornerRadius: 40))
              
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    StatisticView(routines: RoutineItem.sampleData)
}
