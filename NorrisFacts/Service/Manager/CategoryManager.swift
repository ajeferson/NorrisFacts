//
//  CategoryManager.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

protocol CategoryManagerProtocol {
    func cacheCategoriesIfNeeded() -> Completable
}

final class CategoryManager: CategoryManagerProtocol {
    let provider: CategoryProviderProtocol
    let store: CategoryStoreProtocol

    init(provider: CategoryProviderProtocol, store: CategoryStoreProtocol) {
        self.provider = provider
        self.store = store
    }

    func cacheCategoriesIfNeeded() -> Completable {
        store
            .all()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapCompletable { [weak self] categories -> Completable in
                guard let self = self, categories.isEmpty else {
                    return .empty()
                }

                return self.provider
                    .fetchCategories()
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .flatMapCompletable { [weak self] categories -> Completable in
                        guard let self = self else {
                            return .empty()
                        }
                        return self.store.save(categories: categories)
                }
            }
    }
}
