//
//  AddRoutineContainerView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import SwiftUI
import SwiftData

struct AddRoutineContainerView: View {
    
    let modelContext: ModelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddRoutineViewModel
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _viewModel = State(initialValue: AddRoutineViewModel(context: modelContext))
    }
    
    var body: some View {
        VStack {
            HStack {
                if viewModel.step == .info {
                    Spacer()
                }
                Button {
                   goBack()
                } label: {
                    Image(systemName: viewModel.step == .info ? "xmark" : "chevron.left")
                }
                if viewModel.step != .info {
                    Spacer()
                }
            }
            .overlay {
                Text(viewModel.step == .info ? "루틴 등록" : "할 일 등록")
                    .font(.ptSemiBold())
            }
            .padding()
            
            ProgressView(value: viewModel.step.rawValue, total: 1.0)
                .progressViewStyle(.linear)
                .padding(.horizontal)

            switch viewModel.step {
            case .info:
                AddRoutineView(viewModel: viewModel)
            case .task:
                AddRoutineTaskView(viewModel: viewModel)
            }
            
            Spacer()
            .onChange(of: viewModel.isCompleted) {
                dismiss()
            }
        }
    }
    private func goBack() {
        switch viewModel.step {
        case .info:
            dismiss()
        case .task:
            viewModel.step = .info
        }
    }
}

#Preview {
    let modelContainer: ModelContainer
    do {
        modelContainer = try ModelContainer(for: RoutineItem.self, TaskList.self)
    } catch {
        fatalError("❌ Could not initialize ModelContainer: \(error.localizedDescription)")
    }
    return AddRoutineContainerView(modelContext: modelContainer.mainContext)
}
