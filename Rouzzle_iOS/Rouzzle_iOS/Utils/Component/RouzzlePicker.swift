//
//  RouzzlePicker.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/15/25.
//

import SwiftUI

struct RouzzlePicker: View {
    let unit: String
    let isDisabled: Bool
    let options: [Int]
    @Binding var selection: Int?
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { value in
                Button {
                    selection = value
                } label: {
                    Text("\(value)\(unit)")
                }
            }
        } label: {
            Text("\(selection ?? 0)\(unit)")
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
        }
        .frame(height: 40)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 10))
        .tint(.accent)
        .disabled(isDisabled)
    }
}
