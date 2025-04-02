//
//  RecommendViewModel.swift
//  Rouzzle_iOS
//
//  Created by 이다영 on 4/2/25.
//

import Foundation
import Factory
import SwiftData

enum LoadState {
    case none
    case loading
    case loaded
    case error
}

@MainActor
@Observable
final class RecommendViewModel {

    // MARK: - DI
    @ObservationIgnored
    @Injected(\.swiftDataService) private var routineService: SwiftDataServiceProtocol

    // MARK: - 추천 카테고리
    enum Category: String, CaseIterable {
        case celebrity = "유명인"
        case morning = "아침"
        case evening = "저녁"
        case health = "건강"
        case pet = "반려동물"
        case productivity = "생산성"
        case rest = "휴식"
    }

    // MARK: - 상태 프로퍼티
    var loadState: LoadState = .none
    var toastMessage: String?
    var selectedCategory: Category = .celebrity {
        didSet {
            updateCards()
        }
    }

    var filteredCards: [Card] = []
    var selectedRecommend: [RecommendTodoTask] = []

    // MARK: - 카드 데이터
    private let allCards: [Category: [Card]] = [
        .celebrity: DummyCardData.celebrityCards,
        .morning: DummyCardData.morningCards,
        .evening: DummyCardData.eveningCards,
        .health: DummyCardData.healthCards,
        .pet: DummyCardData.petCards,
        .productivity: DummyCardData.productivityCards,
        .rest: DummyCardData.restCards
    ]

    // MARK: - 초기화
    init() {
        updateCards()
    }

    private func updateCards() {
        filteredCards = allCards[selectedCategory] ?? []
    }

    // MARK: - 루틴 저장
    func addTask(_ routineItem: RoutineItem) async {
        loadState = .loading
        do {
            try routineService.addRoutine(routineItem)
            toastMessage = "루틴이 저장되었어요!"
            loadState = .loaded
        } catch {
            toastMessage = "루틴 저장에 실패했어요 😢"
            loadState = .error
        }
    }
}
