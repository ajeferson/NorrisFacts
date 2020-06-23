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
    func all(limit: Int) -> Single<[Query]> {
        return .just([])
    }

    func save(query: Query) -> Completable {
        return .empty()
    }
}
