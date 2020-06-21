//
//  MockFactListCoordinator.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
@testable import NorrisFacts

final class MockFactListCoordinator: FactListCoordinatorProtocol {
    var startSearchCalls = 0

    func start() {
    }

    func startSearch() {
        startSearchCalls += 1
    }
}
