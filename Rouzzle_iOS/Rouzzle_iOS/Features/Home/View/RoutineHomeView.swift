//
//  RoutineListView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI
import SwiftData

// Navigation Path
enum NavigationDestination: Hashable {
    case addTaskView
    case routineCompleteView
}

// Main View
struct RoutineHomeView: View {
    @Query private var routines: [RoutineItem]
    @State private var isShowingAddRoutineSheet: Bool = false
    @State private var path = NavigationPath()
    @State private var routineHomeViewModel = RoutineHomeViewModel()
    @State private var selectedFilter = false
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                HeaderView(quoteText: routineHomeViewModel.currentQuote)
                    .padding()
                HStack {
                    RoutineFilterToggle(isToday: $selectedFilter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {isShowingAddRoutineSheet.toggle()}) {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                ForEach(routines) { routine in
                    RoutineItemView(routine: routine) {
                        path.append(NavigationDestination.addTaskView)
                    }
                }
                
                Button {
                    isShowingAddRoutineSheet.toggle()
                } label: {
                    Image(.requestRoutine)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                }
            }
            .fullScreenCover(isPresented: $isShowingAddRoutineSheet) {
                AddRoutineContainerView()
            }
            .refreshable {
                routineHomeViewModel.updateQuote()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("🧩 루틴 10일차 · 🔥 연속 성공 5일차")
                        .font(.ptLight(.caption2))
                        .foregroundStyle(.gray)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .font(.title3)
                    }
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .addTaskView:
                    AddRoutineContainerView()
                case .routineCompleteView:
                    EmptyView()
                }
            }
            
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RoutineItem.self, TaskList.self, configurations: config)
    
    let context = container.mainContext
    RoutineItem.sampleData.forEach { routine in
        context.insert(routine)
    }
    
    return RoutineHomeView()
        .modelContainer(container)
}

