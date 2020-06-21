//
//  MockFactsProvider.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift
@testable import NorrisFacts

final class MockFactsProvider: FactsProviderProtocol {
    var searchResults = [Fact]()

    func search(query: String) -> Single<[Fact]> {
        .just(searchResults)
    }

    func fetchCategories() -> Single<[String]> {
        .just([])
    }
}
