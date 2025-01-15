//
//  AddRoutineViewModel.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import Foundation
import Combine

@Observable
final class AddRoutineViewModel {
    // MARK: - Types
    enum Step: Double {
        case info = 0.5
        case task = 1.0
    }
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    private let dailySubject = CurrentValueSubject<Bool, Never>(false)
    
    var step: Step = .info
    var title: String = ""
    var selectedEmoji: String? = "🧩"
    var selectedDateWithTime: [Day: Date] = [:]
    
    var isDaily: Bool {
        get {
            selectedDateWithTime.count > 6 ? true : false
        }
    }
    
    var firstDayTime: String? {
        selectedDateWithTime
            .sorted(by: {$0.key.rawValue < $1.key.rawValue })
            .first
            .map { $0.value.formatted(.dateTime.hour().minute()) }
    }
    
    var isCompleted: Bool = false
    
    init() {
        
    }
    
    func toggleDaily() {
        if selectedDateWithTime.isEmpty {
            let currentDate = Date()
            for day in Day.allCases {
                selectedDateWithTime[day] = currentDate
            }
        } else {
            selectedDateWithTime.removeAll()
        }
    }
    // 특정 요일이 선택되어 있는지 확인하는 함수
    func isSelected(_ day: Day) -> Bool {
        return selectedDateWithTime[day] != nil
    }
    // 개별 요일 토글
    func toggleDay(_ day: Day) {
        if isSelected(day) {
            selectedDateWithTime.removeValue(forKey: day)
        } else {
            selectedDateWithTime[day] = Date()
        }
    }
    
    func checkIfTimesAreDifferent() -> Bool {
        let uniqueTimes = Set(selectedDateWithTime.values.map {
            Calendar.current.dateComponents([.hour, .minute], from: $0)
        })
        return uniqueTimes.count > 1
    }
    
    private func validateForm() {
        isCompleted = !title.isEmpty && selectedEmoji != ""
    }
}
