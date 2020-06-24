//
//  QueryFactory.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
@testable import NorrisFacts

struct QueryFactory {
    static func makeQuery() -> Query {
        Query(name: "query")
    }

    static func makeQueryWithFacts() -> Query {
        let fact = FactFactory.makeFact()
        let query = makeQuery()
        query.facts.append(fact)
        return query
    }
}
