//
//  CategoryManagerTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxSwift
@testable import NorrisFacts

final class CategoryManagerTests: QuickSpec {
    override func spec() {
        describe("CategoryManager") {
            var provider: MockCategoryProvider!
            var store: MockCategoryStore!
            var manager: CategoryManager!

            beforeEach {
                provider = MockCategoryProvider()
                store = MockCategoryStore()
                manager = CategoryManager(provider: provider,
                                          store: store,
                                          scheduler: MainScheduler.instance)
            }

            afterEach {
                provider = nil
                store = nil
                manager = nil
            }

            describe("cacheCategoriesIfNeeded") {
                context("no previously saved categories") {
                    it("fetches and stores categories") {
                        store.allCategories = []

                        let allCategories = CategoryFactory.makeAllCategories()
                        provider.fetchedCategories = allCategories

                        _ = try! manager.cacheCategoriesIfNeeded().toBlocking().first()

                        expect(store.allCalls).to(equal(1))
                        expect(provider.fetchCalls).to(equal(1))
                        expect(store.saveCalls).to(equal(1))
                        expect(store.savedCategories).to(equal(allCategories))
                    }
                }

                context("previously saved categories") {
                    it("doesn't fetch nor store categories") {
                        let allCategories = CategoryFactory.makeAllCategories()
                        store.allCategories = allCategories
                        provider.fetchedCategories = allCategories

                        _ = try! manager.cacheCategoriesIfNeeded().toBlocking().first()

                        expect(store.allCalls).to(equal(1))
                        expect(provider.fetchCalls).to(equal(0))
                        expect(store.saveCalls).to(equal(0))
                    }
                }
            }
        }
    }
}
