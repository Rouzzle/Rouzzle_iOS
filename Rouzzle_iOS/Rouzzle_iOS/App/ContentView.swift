//
//  ContentView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/4/25.
//

import SwiftUI
import Combine

struct ContentView: View {
        
    var body: some View {
        TabView {
            RoutineListView()
                .tabItem {
                    Text("홈")
                    Image(systemName: "house.fill")
                }
            
            StatisticView()
                .tabItem {
                    Text("통계")
                    Image(systemName: "list.bullet.clipboard.fill")
                }
            
            RecommendView()
                .tabItem {
                    Text("추천")
                    Image(systemName: "star.fill")
                }
            
            SocialView()
                .tabItem {
                    Text("소셜")
                    Image(systemName: "person.3.fill")
                }
            
            MyPageView()
                .tabItem {
                    Text("마이페이지")
                    Image(systemName: "person.circle.fill")
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
