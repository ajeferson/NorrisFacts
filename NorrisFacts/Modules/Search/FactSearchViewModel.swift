//
//  FactSearchViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

struct FactSearchViewModelInput {
    let cancelButtonClicked: Observable<Void>
    let searchButtonClicked: Observable<Void>
    let searchText: Observable<String?>
}

protocol FactSearchViewModelProtocol {
    func bind(input: FactSearchViewModelInput) -> Disposable
}

final class FactSearchViewModel: FactSearchViewModelProtocol {
    weak var coordinator: FactSearchCoordinatorProtocol?

    init(coordinator: FactSearchCoordinatorProtocol) {
        self.coordinator = coordinator
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
                self?.coordinator?.finish(query: nil)
            })
    }

    private func bindSearch(_ input: FactSearchViewModelInput) -> Disposable {
        input
            .searchButtonClicked
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.coordinator?.finish(query: query)
            })
    }
}
