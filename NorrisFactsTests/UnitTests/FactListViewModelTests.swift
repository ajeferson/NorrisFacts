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
            var viewModel: FactListViewModel!

            beforeEach {
                coordinator = MockFactListCoordinator()
                viewModel = FactListViewModel(coordinator: coordinator)
            }

            afterEach {
                coordinator = nil
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
        }
    }
}
