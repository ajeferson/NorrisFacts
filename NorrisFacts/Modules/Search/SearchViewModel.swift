//
//  SearchViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

struct SearchViewModelInput {
    let searchButtonClicked: Observable<Void>
    let searchText: Observable<String?>
}

protocol SearchViewModelProtocol {
    func bind(input: SearchViewModelInput) -> Disposable
}

final class SearchViewModel: SearchViewModelProtocol {
    func bind(input: SearchViewModelInput) -> Disposable {
        bindSearch(input)
    }

    private func bindSearch(_ input: SearchViewModelInput) -> Disposable {
        input
            .searchButtonClicked
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe()
    }
}
