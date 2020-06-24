//
//  FactListItemViewModelTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
@testable import NorrisFacts

final class FactListItemViewModelTests: QuickSpec {
    override func spec() {
        fdescribe("FactListItemViewModelTests") {
            context("category") {
                context("fact with categories") {
                    it("returns first category uppercased") {
                        let fact = Fact(id: "12345",
                                        url: "https://some.url",
                                        value: "Some fun fact",
                                        iconUrl: "https://some-icon.url",
                                        categories: ["political", "animal"])
                        let viewModel = FactListItemViewModel(fact: fact)
                        expect(viewModel.category).to(equal("POLITICAL"))
                    }
                }

                context("fact with no categories") {
                    it("returns UNCATEGORIZED") {
                        let fact = Fact(id: "12345",
                                        url: "https://some.url",
                                        value: "Some fun fact",
                                        iconUrl: "https://some-icon.url",
                                        categories: [])
                        let viewModel = FactListItemViewModel(fact: fact)
                        expect(viewModel.category).to(equal("UNCATEGORIZED"))
                    }
                }

            }

            context("font size") {
                context("fact with long value") {
                    it("returns small font size") {
                        let fact = Fact(id: "12345",
                                        url: "https://some.url",
                                        value: "Thousands of years ago Chuck Norris came across a bear. " +
                                               "It was so terrified that it fled north into the arctic. " +
                                               "It was also so terrified that all of its decendents now have white hair.",
                                        iconUrl: "https://some-icon.url",
                                        categories: [])
                        let viewModel = FactListItemViewModel(fact: fact)
                        expect(viewModel.fontSize).to(equal(16))
                    }
                }

                context("fact with short value") {
                    it("returns large font size") {
                        let fact = Fact(id: "12345",
                                        url: "https://some.url",
                                        value: "Some fun fact",
                                        iconUrl: "https://some-icon.url",
                                        categories: [])
                        let viewModel = FactListItemViewModel(fact: fact)
                        expect(viewModel.fontSize).to(equal(22))
                    }
                }
            }
        }
    }
}
