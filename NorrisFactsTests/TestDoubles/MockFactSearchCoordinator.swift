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
    var finishCalls = [String?]()

    func start() {
    }

    func finish(query: String?) {
        finishCalls.append(query)
    }
}
