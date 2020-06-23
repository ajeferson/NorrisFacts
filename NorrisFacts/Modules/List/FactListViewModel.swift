//
//  FactListViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct FactListViewModelInput {
    let searchBarButtonTap: Observable<Void>
    let factTap: Observable<Int>
}

struct FactListViewModelOutput {
    let items: Driver<[FactListItemViewModel]>
    let isShowingItems: Driver<Bool>
    let message: Driver<String?>
    let sharedItems: Driver<[Any]>
}

protocol FactListViewModelProtocol {
    var output: FactListViewModelOutput { get }

    func bind(input: FactListViewModelInput) -> Disposable
    func update(searchResult: SearchResult)
}

final class FactListViewModel: FactListViewModelProtocol {
    private enum Constants {
        static let searchHint = "Tap search to start"
        static let emptySearchResult = "No results"
    }

    weak var coordinator: FactListCoordinatorProtocol?

    private let itemsSubject = BehaviorRelay<[FactListItemViewModel]>(value: [])
    private let shareItemsSubject = PublishSubject<[Any]>()
    private let message = BehaviorRelay<String?>(value: Constants.searchHint)

    var output: FactListViewModelOutput {
        .init(
            items: itemsSubject.asDriver(onErrorJustReturn: []),
            isShowingItems: itemsSubject
                .map { !$0.isEmpty }
                .asDriver(onErrorJustReturn: false),
            message: message.asDriver(onErrorJustReturn: nil),
            sharedItems: shareItemsSubject.asDriver(onErrorJustReturn: [])
        )
    }

    init(coordinator: FactListCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func bind(input: FactListViewModelInput) -> Disposable {
        Disposables.create(
            // Search button tapped
            input
                .searchBarButtonTap
                .subscribe { [weak self] event in
                    guard case .next = event else { return }
                    self?.coordinator?.startSearch()
                },

            // Shared fact
            input
                .factTap
                .withLatestFrom(
                    Observable.combineLatest(input.factTap, itemsSubject)
                )
                .map { index, itemViewModels in
                    itemViewModels[index].shareableItems
                }
                .bind(to: shareItemsSubject)
        )
    }

    func update(searchResult: SearchResult) {
        guard case .success(let facts) = searchResult else {
            return
        }

        message.accept(facts.isEmpty ? Constants.emptySearchResult : nil)

        let itemViewModels = facts.map { fact in
            FactListItemViewModel(fact: fact)
        }
        itemsSubject.accept(itemViewModels)
    }
}
