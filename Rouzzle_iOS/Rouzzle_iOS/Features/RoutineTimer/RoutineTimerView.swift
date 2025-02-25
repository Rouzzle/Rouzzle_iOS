//
//  RoutineTimerView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/25/25.
//

import SwiftUI

struct RoutineTimerView: View {
    var routine: RoutineItem
    var body: some View {
        Text("RoutineTimerView")
    }
}

#Preview {
    RoutineTimerView(routine: RoutineItem.sampleData[0])
}
