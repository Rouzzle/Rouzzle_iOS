//
//  UserInformationView.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 5/16/25.
//

import SwiftUI

struct UserInformationView: View {
    
    var nickname: String
    var routineDays: Int
    var consecutiveDays: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 0) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(uiColor: .systemGray3))
                    .padding()
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(nickname)
                            .font(.ptBold(.title2))
                        
                        Text("루즐러")
                            .font(.ptBold(.headline))
                            .foregroundColor(.accentColor)
                    }
                    
                    Text("🌱 루틴 \(routineDays)일차 🔥 연속 성공 \(consecutiveDays)일차")
                        .font(.ptLight(.subheadline))
                }
                Spacer()
            }
        }
    }
}

#Preview {
    UserInformationView(
        nickname: "효짱",
        routineDays: 10,
        consecutiveDays: 5
    )
}
