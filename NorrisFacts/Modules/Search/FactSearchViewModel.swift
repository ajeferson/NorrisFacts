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
    let searchButtonClicked: Observable<Void>
    let searchText: Observable<String?>
}

protocol FactSearchViewModelProtocol {
    func bind(input: FactSearchViewModelInput) -> Disposable
}

final class FactSearchViewModel: FactSearchViewModelProtocol {
    func bind(input: FactSearchViewModelInput) -> Disposable {
        bindSearch(input)
    }

    private func bindSearch(_ input: FactSearchViewModelInput) -> Disposable {
        input
            .searchButtonClicked
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe()
    }
}
