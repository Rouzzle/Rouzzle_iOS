//
//  MyPageView.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 5/16/25.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            UserInformationView(
                nickname: "효짱",
                routineDays: 5,
                consecutiveDays: 10)
            Spacer()
        }
    }
}

#Preview {
    MyPageView()
}
