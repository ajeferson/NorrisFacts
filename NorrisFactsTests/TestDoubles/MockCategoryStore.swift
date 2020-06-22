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
    func all() -> Single<[NorrisFacts.Category]> {
        Single.just([])
    }

    func save(categories: [NorrisFacts.Category]) -> Completable {
        .empty()
    }
}
