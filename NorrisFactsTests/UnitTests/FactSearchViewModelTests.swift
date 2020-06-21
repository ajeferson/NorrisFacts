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
            var viewModel: FactSearchViewModel!

            beforeEach {
                coordinator = MockFactSearchCoordinator()
                viewModel = FactSearchViewModel(coordinator: coordinator)
            }

            afterEach {
                coordinator = nil
                viewModel = nil
            }

            context("cancel button clicked") {
                it("finishes coordinator without query") {
                    let scheduler = TestScheduler(initialClock: 0)
                    let cancelTaps = scheduler.createColdObservable([.next(0, ())])

                    let input = FactSearchViewModelInput(
                        cancelButtonClicked: cancelTaps.asObservable(),
                        searchButtonClicked: .never(),
                        searchText: .never()
                    )

                    _ = viewModel.bind(input: input)

                    expect(coordinator.finishCalls).to(haveCount(0))

                    scheduler.start()

                    expect(coordinator.finishCalls).to(haveCount(1))
                    expect(coordinator.finishCalls[0]).to(beNil())
                }
            }

            context("search performed") {
                it("finishes coordinator with query") {
                    let scheduler = TestScheduler(initialClock: 0)
                    let searchText: TestableObservable<String?> = scheduler.createColdObservable([.next(0, "night")])
                    let searchButonTap = scheduler.createColdObservable([.next(0, ())])

                    let input = FactSearchViewModelInput(
                        cancelButtonClicked: .never(),
                        searchButtonClicked: searchButonTap.asObservable(),
                        searchText: searchText.asObservable()
                    )

                    _ = viewModel.bind(input: input)

                    expect(coordinator.finishCalls).to(haveCount(0))

                    scheduler.start()

                    expect(coordinator.finishCalls).to(haveCount(1))
                    expect(coordinator.finishCalls[0]).to(equal("night"))
                }
            }
        }
    }
}
