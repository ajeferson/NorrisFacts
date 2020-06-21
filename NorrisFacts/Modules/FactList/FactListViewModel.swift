//
//  FactListViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

struct FactListViewModelInput {
    let searchBarButtonTap: Observable<Void>
}

protocol FactListViewModelProtocol {
    func bind(input: FactListViewModelInput) -> Disposable
}

final class FactListViewModel: FactListViewModelProtocol {
    weak var router: FactListRouter?

    init(router: FactListRouter) {
        self.router = router
    }

    func bind(input: FactListViewModelInput) -> Disposable {
        input
            .searchBarButtonTap
            .subscribe { [weak self] event in
                guard case .next = event else { return }
                self?.router?.presentSearch()
            }
    }
}
