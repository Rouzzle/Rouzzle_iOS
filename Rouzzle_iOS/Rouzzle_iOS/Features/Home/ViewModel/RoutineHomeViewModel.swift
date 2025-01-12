//
//  RoutineHomeViewModel.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import Foundation
import SwiftUI

@Observable
final class RoutineHomeViewModel {
    var currentQuote = QuotesProvider.shared.provideQuote()

    func updateQuote() {
        currentQuote = QuotesProvider.shared.provideQuote()
    }
}
