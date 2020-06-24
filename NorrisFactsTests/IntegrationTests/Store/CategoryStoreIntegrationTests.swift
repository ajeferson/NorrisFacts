//
//  CategoryStoreIntegrationTests.swift
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
@testable import NorrisFacts

final class CategoryStoreIntegrationTests: QuickSpec, RealmConfigurableTests {
    override func spec() {
        describe("CategoryStore") {
            var realm: Realm!
            var store: CategoryStore!

            beforeEach {
                self.configureInMemoryTestableRealmInstance()

                realm = try! Realm()
                store = CategoryStore()
            }

            afterEach {
                realm = nil
                store = nil
            }

            describe("all") {
                it("returns previously saved categories") {
                    var resultCategories = try! store.all().toBlocking().first()!
                    expect(resultCategories).to(beEmpty())

                    let categories = CategoryFactory.makeAllCategories()
                    try! realm.write {
                        realm.add(categories)
                    }

                    resultCategories = try! store.all().toBlocking().first()!
                    expect(resultCategories.map { $0.name }).to(equal(categories.map { $0.name }))
                }
            }

            describe("save") {
                it("properly persist categories") {
                    var resultCategories = realm.objects(Category.self)
                    expect(resultCategories).to(beEmpty())

                    let categories = CategoryFactory.makeAllCategories()
                    _ = try! store.save(categories: categories).toBlocking().first()

                    resultCategories = realm.objects(Category.self)
                    expect(resultCategories.map { $0.name }).to(equal(categories.map { $0.name }))
                }
            }
        }
    }
}
