//
//  StatisticView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI

struct StatisticView: View {
    var routines: [RoutineItem]
    var body: some View {
        Text("\(routines.count)")
    }
}

#Preview {
    StatisticView(routines: RoutineItem.sampleData)
}
