//
//  HeaderView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 2/24/25.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    let quoteText: String
    var body: some View {
        VStack {
            Text(quoteText)
                .font(.ptSemiBold(.title3))
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .top)
                .padding(.top, 5)
        }
    }
}
