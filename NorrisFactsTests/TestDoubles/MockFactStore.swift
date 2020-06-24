//
//  MockFactStore.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift
@testable import NorrisFacts

final class MockFactStore: FactStoreProtocol {
    func sample(maxAmount: Int) -> Single<[Fact]> {
        .just([])
    }
}
