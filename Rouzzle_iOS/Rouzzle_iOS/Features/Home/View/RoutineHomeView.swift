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
    case routineTimerView(routine: RoutineItem) // 어떤 루틴이 선택되었는지 넘겨주기
}

// Main View
struct RoutineHomeView: View {
    var routines: [RoutineItem]
    @State private var isShowingAddRoutineSheet: Bool = false
    @State private var path = NavigationPath()
    @State private var routineHomeViewModel = RoutineHomeViewModel()
    @State private var selectedFilter = false

    var filteredRoutines: [RoutineItem] {
        if selectedFilter {
            let today = Calendar.current.component(.weekday, from: Date())
            return routines.filter { routine in
                routine.dayStartTime.keys.contains(today)
            }
        } else {
            return routines
        }
    }
    
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
                
                ForEach(filteredRoutines) { routine in
                    RoutineItemView(routine: routine) {
                        path.append(NavigationDestination.routineTimerView(routine: routine))
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
                case .routineTimerView(let routine):
                    TaskListView(path: $path, viewModel: TaskListViewModel(routineItem: routine))
                }
            }
            
        }
    }
}

#Preview {
    RoutineHomeView(routines: RoutineItem.sampleData)
}

