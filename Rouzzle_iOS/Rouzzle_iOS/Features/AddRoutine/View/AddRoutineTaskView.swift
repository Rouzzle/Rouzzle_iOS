//
//  AddRoutineTaskView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import SwiftUI

struct AddRoutineTaskView: View {
    @Bindable var viewModel: AddRoutineViewModel
    @State var routineByTime: RoutineCategoryByTime?

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AddRoutineTaskView(viewModel: .init())
}
