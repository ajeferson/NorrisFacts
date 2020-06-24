//
//  FactFactory.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
@testable import NorrisFacts

struct FactFactory {
    static func makeFact() -> Fact {
        Fact(id: "12345",
             url: "https://some.url",
             value: "Some fun fact",
             iconUrl: "https://some-icon.url",
             categories: ["political", "animal"])
    }

    static func makeLongValueFact() -> Fact {
        Fact(id: "12345",
             url: "https://some.url",
             value: """
                    Thousands of years ago Chuck Norris came across a bear.
                    It was so terrified that it fled north into the arctic.
                    It was also so terrified that all of its decendents now have white hair.
                    """,
             iconUrl: "https://some-icon.url",
             categories: [])
    }

    static func makeUncategorizedFact() -> Fact {
        Fact(id: "12345",
             url: "https://some.url",
             value: "Some fun fact",
             iconUrl: "https://some-icon.url",
             categories: [])
    }
}
