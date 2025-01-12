//
//  RoutineListView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI
import SwiftData

// Your enums remain the same
enum NavigationDestination: Hashable {
    case addTaskView
    case routineCompleteView
}

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
                        .font(.bold40)
                        .padding(.trailing, 10)
                        .padding(.bottom, 7)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(routine.title)
                            .font(.semibold18)
                            .foregroundStyle(.black)
                            .bold()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        HStack(spacing: 5) {
                            Image(systemName: "bell")
                        }
                        .font(.regular14)
                        Text(convertDaysToString(days: routine.dayStartTime.keys.sorted()))
                            .font(.regular14)
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

struct HeaderView: View {
    let onAddTap: () -> Void
    let quoteText: String
    var body: some View {
        VStack {
            Text(quoteText)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .top)
                .padding(.top, 5)
            
            HStack {
                Button(action: onAddTap) {
                    Image(systemName: "plus")
                        .font(.title)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
        }
    }
}

// Main View
struct RoutineHomeView: View {
    @Query private var routines: [RoutineItem]
    @State private var isShowingAddRoutineSheet: Bool = false
    @State private var isShowingChallengeView: Bool = false
    @State private var path = NavigationPath()
    @State private var routineHomeViewModel = RoutineHomeViewModel()
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                HeaderView(onAddTap: { isShowingAddRoutineSheet.toggle() }, quoteText: routineHomeViewModel.currentQuote)
                
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
            .refreshable {
                routineHomeViewModel.updateQuote()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ChallengeButton(onTap: { isShowingChallengeView.toggle() })
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .addTaskView:
                    EmptyView()
                case .routineCompleteView:
                    EmptyView()
                }
            }
            .navigationDestination(isPresented: $isShowingChallengeView) {
                EmptyView()
            }
        }
    }
}

struct ChallengeButton: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: "trophy.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.yellow)
                    .frame(width: 18, height: 18)
                Text("챌린지")
                    .font(.medium16)
                    .foregroundColor(.black)
            }
            .frame(width: 90, height: 30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 2)
            )
        }
    }
}

// Helper functions
func convertDaysToString(days: [Int]) -> String {
    let dayNames = ["일", "월", "화", "수", "목", "금", "토"]
    
    let dayStrings = days.compactMap { dayIndex -> String? in
        guard dayIndex >= 1 && dayIndex <= 7 else { return nil }
        return dayNames[dayIndex - 1]
    }
    
    if days.contains(1) && days.contains(7) && days.count == 7 {
        return "매일"
    } else if Set([2, 3, 4, 5, 6]).isSubset(of: days) && !days.contains(1) && !days.contains(7) {
        return "평일"
    } else if Set([1, 7]).isSubset(of: days) && days.count == 2 {
        return "주말"
    } else {
        return dayStrings.joined(separator: " ")
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

