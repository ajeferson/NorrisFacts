//
//  CategoryListViewModelTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
@testable import NorrisFacts

final class CategoryListViewModelTests: QuickSpec {
    override func spec() {
        describe("CategoryListViewModel") {
            var scheduler: TestScheduler!
            var categoryStore: MockCategoryStore!
            var viewModel: CategoryListViewModel!

            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                categoryStore = MockCategoryStore()
                viewModel = CategoryListViewModel(categoryStore: categoryStore)
            }

            afterEach {
                scheduler = nil
                categoryStore = nil
                viewModel = nil
            }

            context("categories") {
                it("emits 8 random categories upon load input") {
                    let allCategories = CategoryFactory.makeAllCategories()
                    categoryStore.allCategories = allCategories

                    let observer = scheduler.createObserver([String].self)
                    _ = viewModel.output.categories.drive(observer)

                    let trigger = scheduler.createColdObservable([.next(5, ())])
                    let input = CategoryListViewModelInput(
                        loadCategories: trigger.asObservable(),
                        categoryTap: .empty()
                    )
                    _ = viewModel.bind(input: input)

                    scheduler.start()

                    expect(observer.events[0]).to(equal(.next(0, [])))
                    expect(observer.events[1].time).to(equal(5))

                    let uppercasedCategories = CategoryFactory.makeAllStringCategories().map { $0.uppercased() }
                    let observedCategories = observer.events[1].value.element!
                    expect(observedCategories).to(haveCount(8))
                    expect(uppercasedCategories).to(contain(observedCategories))
                }
            }
        }
    }
}
