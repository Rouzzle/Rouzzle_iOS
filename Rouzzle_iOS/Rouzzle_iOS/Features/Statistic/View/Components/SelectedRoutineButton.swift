//
//  SelectedRoutineButton.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI

struct SelectedRoutineButton: View {
    private let title: String
    private let selected: Bool
    let action: () -> Void
    
    init(title: String, selected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.selected = selected
        self.action = action
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.ptSemiBold())
                .foregroundStyle(selected ? .accent : Color(uiColor: .systemGray))
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(selected ? .rzfcfff0 : .white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(selected ? Color.accentColor : Color(uiColor: .systemGray), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 40))
        }
        .onTapGesture {
            action()
        }
    }
}