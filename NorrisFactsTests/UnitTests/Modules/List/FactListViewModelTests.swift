//
//  FactListViewModelTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
@testable import NorrisFacts

final class FactListViewModelTests: QuickSpec {
    override func spec() {
        describe("FactListViewModel") {
            var coordinator: MockFactListCoordinator!
            var factStore: MockFactStore!
            var scheduler: TestScheduler!
            var viewModel: FactListViewModel!

            beforeEach {
                coordinator = MockFactListCoordinator()
                factStore = MockFactStore()
                scheduler = TestScheduler(initialClock: 0)
                viewModel = FactListViewModel(coordinator: coordinator, factStore: factStore)
            }

            afterEach {
                coordinator = nil
                factStore = nil
                scheduler = nil
                viewModel = nil
            }

            context("search button tapped") {
                it("starts search module") {
                    let scheduler = TestScheduler(initialClock: 0)
                    let searchBarButtonTap = scheduler.createColdObservable([.next(0, ())])
                    let input = FactListViewModelInput(
                        searchBarButtonTap: searchBarButtonTap.asObservable(),
                        factTap: .empty()
                    )

                    _ = viewModel.bind(input: input)

                    expect(coordinator.startSearchCalls).to(equal(0))
                    scheduler.start()
                    expect(coordinator.startSearchCalls).to(equal(1))
                }
            }

            context("shared items") {
                it("is triggered when fact is tapped") {
                    let sampleFact = FactFactory.makeFact()
                    factStore.sampleFacts.append(sampleFact)

                    let observer = scheduler.createObserver([Any].self)
                    _ = viewModel.output.sharedItems.drive(observer)

                    let trigger = scheduler.createColdObservable([.next(5, 0)])
                    let input = FactListViewModelInput(
                        searchBarButtonTap: .empty(),
                        factTap: trigger.asObservable()
                    )
                    _ = viewModel.bind(input: input)

                    scheduler.start()

                    let event = observer.events[0]
                    expect(event.time).to(equal(5))
                }
            }

            context("message") {
                context("when first launch") {
                    it("returns hint message") {
                        let observer = scheduler.createObserver(String?.self)
                        _ = viewModel.output.message.drive(observer)

                        let input = FactListViewModelInput(
                            searchBarButtonTap: .empty(),
                            factTap: .empty()
                        )
                        _ = viewModel.bind(input: input)

                        expect(observer.events.last).to(equal(.next(0, "Tap search to start")))
                    }
                }

                context("previously saved facts") {
                    it("is nil") {
                        let fact = Fact(id: "12345",
                                        url: "https://some.url",
                                        value: "Some fun fact",
                                        iconUrl: "https://some-icon.url",
                                        categories: ["political", "animal"])
                        factStore.sampleFacts.append(fact)

                        let observer = scheduler.createObserver(String?.self)
                        _ = viewModel.output.message.drive(observer)

                        let input = FactListViewModelInput(
                            searchBarButtonTap: .empty(),
                            factTap: .empty()
                        )
                        _ = viewModel.bind(input: input)

                        expect(observer.events.last).to(equal(.next(0, nil)))
                    }
                }

                context("empty search results") {
                    it("equals no results") {
                        let observer = scheduler.createObserver(String?.self)
                        _ = viewModel.output.message.drive(observer)

                        let searchResult = SearchResult.success([])
                        viewModel.update(searchResult: searchResult)

                        expect(observer.events[1]).to(equal(.next(0, "No results")))
                    }
                }
            }

            context("items") {
                context("cancelled search result") {
                    it("doesn't emit") {
                        let observer = scheduler.createObserver([FactListItemViewModel].self)
                        _ = viewModel.output.items.drive(observer)

                        viewModel.update(searchResult: .cancel)

                        expect(observer.events.count).to(equal(1))
                        expect(observer.events.first?.value.element).to(beEmpty())
                    }
                }

                context("success search result") {
                    it("emits") {
                        let fact = FactFactory.makeFact()
                        factStore.sampleFacts.append(fact)

                        let observer = scheduler.createObserver([FactListItemViewModel].self)
                        _ = viewModel.output.items.drive(observer)

                        let searchResult = SearchResult.success([fact])
                        viewModel.update(searchResult: searchResult)

                        // 1 empty value, 1 actual emitted fact
                        expect(observer.events.count).to(equal(2))
                        expect(observer.events.first?.value.element).to(beEmpty())

                        let items = observer.events[1].value.element
                        expect(items?.count).to(equal(1))
                        expect(items?.first?.value).to(equal(fact.value))
                        expect(items?.first?.category).to(equal(fact.categories.first?.uppercased()))
                    }
                }
            }

            context("is showing items") {
                context("before updating search results") {
                    it("emits false") {
                        let fact = FactFactory.makeFact()
                        factStore.sampleFacts.append(fact)

                        let observer = scheduler.createObserver(Bool.self)
                        _ = viewModel.output.isShowingItems.drive(observer)

                        expect(observer.events).to(equal([.next(0, false)]))
                    }
                }

                context("after updating search results") {
                    it("emits true") {
                        let fact = FactFactory.makeFact()
                        factStore.sampleFacts.append(fact)

                        let observer = scheduler.createObserver(Bool.self)
                        _ = viewModel.output.isShowingItems.drive(observer)

                        let searchResult = SearchResult.success([fact])
                        viewModel.update(searchResult: searchResult)

                        expect(observer.events).to(equal([
                            .next(0, false),
                            .next(0, true)
                        ]))
                    }
                }
            }
        }
    }
}
