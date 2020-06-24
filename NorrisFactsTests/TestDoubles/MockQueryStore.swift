//
//  MockQueryStore.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/23/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift
@testable import NorrisFacts

final class MockQueryStore: QueryStoreProtocol {
    var savedQueries = [Query]()

    func all(limit: Int) -> Single<[Query]> {
        .just([])
    }

    func getBy(name: String) -> Single<Query?> {
        Single.create { [unowned self] single -> Disposable in
            let query = self.savedQueries.first { $0.name == name }
            single(.success(query))
            return Disposables.create()
        }
    }

    func save(query: Query, with facts: [Fact]) -> Completable {
        Completable.create { [unowned self] completable -> Disposable in
            query.facts.append(objectsIn: facts)
            self.savedQueries.append(query)
            completable(.completed)
            return Disposables.create()
        }
    }
}
