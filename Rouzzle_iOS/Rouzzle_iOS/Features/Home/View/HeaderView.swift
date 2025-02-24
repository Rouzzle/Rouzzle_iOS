//
//  HeaderView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/24/25.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    let onAddTap: () -> Void
    let quoteText: String
    var body: some View {
        VStack {
            Text(quoteText)
                .font(.ptSemiBold(.title3))
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
