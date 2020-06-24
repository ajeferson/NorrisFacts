//
//  SearchHistoryViewModelIntegrationTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import RealmSwift
import RxSwift
import RxBlocking
import RxTest
@testable import NorrisFacts

final class SearchHistoryViewModelIntegrationTests: QuickSpec, APIFakeableTests, RealmConfigurableTests {
    override func spec() {
        describe("SearchHistoryViewModel") {
            context("repeated searches") {
                func search(query: String) {
                    var coordinator: FactSearchCoordinator!

                    waitUntil { done in
                        coordinator = FactSearchCoordinator(parent: UIViewController(),
                                                            storyboard: Storyboard.main,
                                                            onFinish: { _ in done() })
                        coordinator.start()
                        let factProvider = FactProvider()
                        let categoryStore = CategoryStore()
                        let queryStore = QueryStore()
                        let viewModel = FactSearchViewModel(
                            coordinator: coordinator,
                            factProvider: factProvider,
                            categoryStore: categoryStore,
                            queryStore: queryStore,
                            scheduler: MainScheduler.instance
                        )

                        let searchButtonPublisher = PublishSubject<Void>()
                        let input = FactSearchViewModelInput(
                            cancelButtonClicked: .empty(),
                            searchButtonClicked: searchButtonPublisher,
                            searchText: .just(query)
                        )
                        _ = viewModel.bind(input: input)

                        searchButtonPublisher.onNext(())
                    }
                }

                it("doesn't show repeated queries and shows most recent search at the top") {
                    // Need to have Realm instance, otherwise in memory database is wiped out
                    self.configureInMemoryTestableRealmInstance()
                    _ = try! Realm()

                    self.fake(api: .search(query: "viking"), response: .searchSuccess)

                    // 1. Perform searches
                    search(query: "viking")
                    search(query: "valhalla")
                    search(query: "viking")

                    // 2. View last searched queries
                    let queryStore = QueryStore()
                    let viewModel = SearchHistoryViewModel(queryStore: queryStore)

                    let scheduler = TestScheduler(initialClock: 0)
                    let observer = scheduler.createObserver([String].self)
                    _ = viewModel.output.queries.drive(observer)

                    let trigger = scheduler.createColdObservable([.next(5, ())])
                    let input = SearchHistoryViewModelInput(loadQueries: trigger.asObservable())
                    _ = viewModel.bind(input: input)

                    scheduler.start()

                    expect(observer.events).to(equal([
                        .next(0, []),
                        .next(5, ["viking", "valhalla"])
                    ]))

                    // Viking is at position 0, as list is date descending
                    expect(viewModel.numberOfItems).to(equal(2))
                    expect(viewModel.item(for: 0)).to(equal("viking"))
                    expect(viewModel.item(for: 1)).to(equal("valhalla"))
                }
            }
        }
    }
}
