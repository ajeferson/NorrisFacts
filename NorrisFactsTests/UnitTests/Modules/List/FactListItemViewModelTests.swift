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
        describe("FactListItemViewModelTests") {
            context("category") {
                context("fact with categories") {
                    it("returns first category uppercased") {
                        let fact = FactFactory.makeFact()
                        let viewModel = FactListItemViewModel(fact: fact)
                        expect(viewModel.category).to(equal("POLITICAL"))
                    }
                }

                context("fact with no categories") {
                    it("returns UNCATEGORIZED") {
                        let fact = FactFactory.makeUncategorizedFact()
                        let viewModel = FactListItemViewModel(fact: fact)
                        expect(viewModel.category).to(equal("UNCATEGORIZED"))
                    }
                }

            }

            context("font size") {
                context("fact with long value") {
                    it("returns small font size") {
                        let fact = FactFactory.makeLongValueFact()
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

            context("shareable items") {
                it("returns proper value") {
                    let fact = FactFactory.makeFact()
                    let viewModel = FactListItemViewModel(fact: fact)
                    guard let shareableItems = viewModel.shareableItems.first as? String else {
                        fail("Should be a string")
                        return
                    }
                    expect(shareableItems).to(equal("Some fun fact\nhttps://some.url"))
                }
            }
        }
    }
}
