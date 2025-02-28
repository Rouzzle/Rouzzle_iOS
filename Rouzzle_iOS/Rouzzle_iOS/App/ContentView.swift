//
//  ContentView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var routines: [RoutineItem]
    var body: some View {
        
        TabView {
            RoutineHomeView(routines: routines)
                .tabItem {
                    Text("홈")
                    Image(systemName: "house.fill")
                }
            
            StatisticView(routines: routines)
                .tabItem {
                    Text("통계")
                    Image(systemName: "list.bullet.clipboard.fill")
                }
            
            RecommendView()
                .tabItem {
                    Text("추천")
                    Image(systemName: "star.fill")
                }
        }
    }
}

struct RoutineItemRow: View {
    let routineItem: RoutineItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(routineItem.emoji)
                Text(routineItem.title)
                    .font(.headline)
                Spacer()
                if routineItem.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
