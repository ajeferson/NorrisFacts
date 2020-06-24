//
//  MockCategoryStore.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift
@testable import NorrisFacts

final class MockCategoryStore: CategoryStoreProtocol {
    var allCalls = 0
    var allCategories = [NorrisFacts.Category]()

    var saveCalls = 0
    var savedCategories = [NorrisFacts.Category]()

    func all() -> Single<[NorrisFacts.Category]> {
        allCalls += 1
        return .just(allCategories)
    }

    func save(categories: [NorrisFacts.Category]) -> Completable {
        saveCalls += 1
        return Completable.create { [unowned self] completable -> Disposable in
            self.savedCategories.removeAll()
            self.savedCategories.append(contentsOf: categories)
            completable(.completed)
            return Disposables.create()
        }
    }
}
