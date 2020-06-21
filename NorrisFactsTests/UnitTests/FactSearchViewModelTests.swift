//
//  FactSearchViewModelTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
@testable import NorrisFacts

final class FactSearchViewModelTests: QuickSpec {
    override func spec() {
        describe("FactSearchViewModel") {
            var coordinator: MockFactSearchCoordinator!
            var factsProvider: MockFactsProvider!
            var viewModel: FactSearchViewModel!
            var scheduler: TestScheduler!

            beforeEach {
                coordinator = MockFactSearchCoordinator()
                factsProvider = MockFactsProvider()
                scheduler = TestScheduler(initialClock: 0)
                viewModel = FactSearchViewModel(coordinator: coordinator,
                                                factsProvider: factsProvider,
                                                scheduler: scheduler)
            }

            afterEach {
                coordinator = nil
                factsProvider = nil
                scheduler = nil
                viewModel = nil
            }

            context("cancel button clicked") {
                it("finishes coordinator without query") {
                    let cancelTaps = scheduler.createColdObservable([.next(0, ())])
                    let input = FactSearchViewModelInput(
                        cancelButtonClicked: cancelTaps.asObservable(),
                        searchButtonClicked: .never(),
                        searchText: .never()
                    )

                    _ = viewModel.bind(input: input)

                    scheduler.start()
                    expect(coordinator.finishCalls).to(haveCount(1))

                    guard case .cancel = coordinator.finishCalls[0] else {
                        fail("It should be a cancel search result")
                        return
                    }
                }
            }

            context("search performed") {
                it("finishes coordinator with query") {
                    let fact = Fact(id: "12345",
                                    url: "https://some.url",
                                    value: "Some cool joke about Chuck Norris",
                                    iconUrl: "https://some-icon.url",
                                    categories: ["political"])
                    factsProvider.searchResults = [fact]

                    let searchText: TestableObservable<String?> = scheduler.createColdObservable([.next(100, "night")])
                    let searchButonTap = scheduler.createColdObservable([.next(150, ())])
                    let input = FactSearchViewModelInput(
                        cancelButtonClicked: .never(),
                        searchButtonClicked: searchButonTap.asObservable(),
                        searchText: searchText.asObservable()
                    )
                    _ = viewModel.bind(input: input)

                    scheduler.start()
                    expect(coordinator.finishCalls).to(haveCount(1))

                    guard case .success(let facts) = coordinator.finishCalls[0] else {
                        fail("It should be a success search result")
                        return
                    }
                    expect(facts[0]).to(equal(fact))
                }
            }
        }
    }
}
