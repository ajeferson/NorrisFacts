//
//  MockCategoryProvider.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift
@testable import NorrisFacts

final class MockCategoryProvider: CategoryProviderProtocol {
    var fetchCalls = 0
    var fetchedCategories = [NorrisFacts.Category]()

    func fetchCategories(scheduler: SchedulerType, retryOnError: Bool) -> Single<[NorrisFacts.Category]> {
        fetchCalls += 1
        return .just(fetchedCategories)
    }
}
