//
//  BorderModifier.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/19/25.
//

import SwiftUI

struct BorderButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 61)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.accent, lineWidth: 1)
            }
    }
}
