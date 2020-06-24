//
//  MockFactProvider.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift
@testable import NorrisFacts

final class MockFactProvider: FactProviderProtocol {
    var searchResults = [Fact]()

    func search(query: String, scheduler: SchedulerType, retryOnError: Bool) -> Single<[Fact]> {
        .just(searchResults)
    }
}
