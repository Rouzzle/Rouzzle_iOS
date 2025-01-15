//
//  Day.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

enum Day: Int, Codable, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var id: Int { self.rawValue }
    
    var name: String {
        switch self {
        case .sunday:
            "일"
        case .monday:
            "월"
        case .tuesday:
            "화"
        case .wednesday:
            "수"
        case .thursday:
            "목"
        case .friday:
            "금"
        case .saturday:
            "토"
        }
    }
}
