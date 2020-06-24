//
//  CategoryListViewModelIntegrationTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import RealmSwift
import RxBlocking
import RxSwift
import RxTest
@testable import NorrisFacts

final class CategoryListViewModelIntegrationTests: QuickSpec, APIFakeableTests, RealmConfigurableTests {
    override func spec() {
        describe("CategoryListViewModel") {
            it("returns list of random categories after initial workflow") {
                self.configureInMemoryTestableRealmInstance()
                let realm = try! Realm()

                self.fake(api: .categories, response: .fetchCategoriesSuccess)

                let provider = CategoryProvider()
                let store = CategoryStore()
                let manager = CategoryManager(provider: provider,
                                              store: store,
                                              scheduler: MainScheduler.instance)

                // 1. Perform category caching workflow
                _ = try! manager.cacheCategoriesIfNeeded().toBlocking().first()
                let cachedCategories = realm.objects(Category.self)
                expect(cachedCategories.count).to(beGreaterThan(8))

                // 2. View category list
                let viewModel = CategoryListViewModel(categoryStore: store)

                let scheduler = TestScheduler(initialClock: 0)
                let observer = scheduler.createObserver([String].self)
                _ = viewModel.output.categories.drive(observer)

                let trigger = scheduler.createColdObservable([.next(5, ())])
                let input = CategoryListViewModelInput(
                    loadCategories: trigger.asObservable(),
                    categoryTap: .empty()
                )
                _ = viewModel.bind(input: input)

                scheduler.start()

                expect(observer.events).to(haveCount(2))
                expect(observer.events[0].time).to(equal(0))
                expect(observer.events[1].time).to(equal(5))

                let uppercasedCategories = cachedCategories.map { $0.name.uppercased() }
                let observedCategories = observer.events[1].value.element!

                expect(observedCategories).to(haveCount(8))
                expect(uppercasedCategories).to(contain(observedCategories))
            }
        }
    }
}
