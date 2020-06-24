//
//  FactStore.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

protocol FactStoreProtocol: RealmStore {
    func sample(maxAmount: Int) -> Single<[Fact]>
}

final class FactStore: FactStoreProtocol {
    func sample(maxAmount: Int) -> Single<[Fact]> {
        realm()
            .map { realm -> [Fact] in
                let results = realm.objects(Fact.self)
                let indexes = (0..<results.count)
                    .shuffled()
                    .prefix(maxAmount)
                return indexes.map { results[$0] }
            }
    }
}
