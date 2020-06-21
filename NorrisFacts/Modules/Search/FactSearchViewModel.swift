//
//  FactSearchViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct FactSearchViewModelInput {
    let cancelButtonClicked: Observable<Void>
    let searchButtonClicked: Observable<Void>
    let searchText: Observable<String?>
}

struct FactSearchViewModelOutput {
    let isLoading: Driver<Bool>
}

protocol FactSearchViewModelProtocol {
    var output: FactSearchViewModelOutput { get }

    func bind(input: FactSearchViewModelInput) -> Disposable
}

final class FactSearchViewModel: FactSearchViewModelProtocol {
    private let factsProvider: FactsProviderProtocol
    weak var coordinator: FactSearchCoordinatorProtocol?

    private let isLoadingSubject = BehaviorRelay(value: false)
    var output: FactSearchViewModelOutput {
        .init(isLoading: isLoadingSubject.asDriver())
    }

    init(coordinator: FactSearchCoordinatorProtocol, factsProvider: FactsProviderProtocol) {
        self.coordinator = coordinator
        self.factsProvider = factsProvider
    }

    func bind(input: FactSearchViewModelInput) -> Disposable {
        Disposables.create(
            bindCancel(input),
            bindSearch(input)
        )
    }

    private func bindCancel(_ input: FactSearchViewModelInput) -> Disposable {
        input
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.finish(facts: nil)
            })
    }

    private func bindSearch(_ input: FactSearchViewModelInput) -> Disposable {
        let query = input
            .searchButtonClicked
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()

        return Disposables.create(
            // Loading state
            query
                .take(1)
                .map { _ in true }
                .bind(to: isLoadingSubject),

            // Search results
            query
                .flatMapLatest { [weak self] query -> Observable<[Fact]> in
                    guard let self = self else {
                        return .empty()
                    }
                    return self.factsProvider
                        .search(query: query)
                        .asObservable()
                }
                .subscribe(onNext: { [weak self] facts in
                    self?.coordinator?.finish(facts: facts)
                })
        )
    }
}
