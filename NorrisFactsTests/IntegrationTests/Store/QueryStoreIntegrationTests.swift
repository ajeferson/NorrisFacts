//
//  QueryStoreIntegrationTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import RealmSwift
import RxBlocking
@testable import NorrisFacts

final class QueryStoreIntegrationTests: QuickSpec, RealmConfigurableTests {
    override func spec() {
        describe("QueryStore") {
            var queryStore: QueryStore!

            beforeEach {
                self.configureInMemoryTestableRealmInstance()
                queryStore = QueryStore()
            }

            afterEach {
                queryStore = nil
            }

            describe("all") {
                it("returns all saved queries") {
                    let realm = try! Realm()

                    let query = QueryFactory.makeQueryWithFacts()
                    try! realm.write {
                        realm.add(query)
                    }

                    let allQueries = try! queryStore.all(limit: 10).toBlocking().first()!

                    expect(allQueries.count).to(equal(1))
                    expect(allQueries.first?.name).to(equal(query.name))

                    expect(allQueries.first?.facts.count).to(equal(1))
                    expect(allQueries.first?.facts.first).to(equal(query.facts.first))
                }

                it("returns limited queries") {
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(Query(name: "first query"))
                        realm.add(Query(name: "second query"))
                    }

                    let allQueries = try! queryStore.all(limit: 1).toBlocking().first()!

                    expect(allQueries.count).to(equal(1))

                    // Last query added is returned
                    expect(allQueries.first?.name).to(equal("second query"))
                }
            }

            describe("getBy") {
                context("no previously saved query") {
                    it("returns nil") {
                        let query = try! queryStore.getBy(name: "query").toBlocking().first()!
                        expect(query).to(beNil())
                    }
                }

                context("previously saved query") {
                    it("returns nil") {
                        let realm = try! Realm()

                        let query = QueryFactory.makeQuery()
                        try! realm.write {
                            realm.add(query)
                        }

                        let resultQuery = try! queryStore.getBy(name: query.name).toBlocking().first()!
                        expect(resultQuery?.name).to(equal(query.name))
                    }
                }
            }

            describe("save") {
                it("saves properly") {

                    let query = QueryFactory.makeQueryWithFacts()
                    _ = try! queryStore.save(query: query, with: Array(query.facts)).toBlocking().first()

                    let realm = try! Realm()
                    let queries = realm.objects(Query.self)

                    expect(queries).to(haveCount(1))
                    expect(queries.first?.name).to(equal(query.name))
                    expect(queries.first?.facts.first).to(equal(query.facts.first))
                }
            }
        }
    }
}
