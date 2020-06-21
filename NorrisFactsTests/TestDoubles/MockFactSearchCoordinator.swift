//
//  MockFactSearchCoordinator.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
@testable import NorrisFacts

final class MockFactSearchCoordinator: FactSearchCoordinatorProtocol {
    var finishCalls = [SearchResult]()

    func start() {
    }

    func finish(searchResult: SearchResult) {
        finishCalls.append(searchResult)
    }
}
