//
//  Publisher+Extension.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import Foundation
import Combine

extension Publisher {
    func withUnretained<O: AnyObject>(_ owner: O) -> Publishers.CompactMap<Self, (O, Self.Output)> {
        compactMap { [weak owner] output in
            owner == nil ? nil : (owner!, output)
        }
    }
}
