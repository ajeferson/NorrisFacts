//
//  CategoryProviderIntegrationTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
import RxSwift
@testable import NorrisFacts

final class CategoryProviderIntegrationTests: QuickSpec, APIFakeableTests {
    override func spec() {
        describe("CategoryProvider") {
            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("fetch categories") {
                context("request fails") {
                    func verify(statusCode: Int, returnsError expectedError: APIError) {
                        self.fake(api: .categories, statusCode: statusCode)

                        let provider = CategoryProvider()
                        let result = provider
                            .fetchCategories(scheduler: MainScheduler.instance, retryOnError: false)
                            .toBlocking()
                            .materialize()

                        guard case let .failed(elements, error) = result else {
                            fail("Request should fail")
                            return
                        }

                        expect(elements).to(haveCount(0))

                        guard let apiError = error as? APIError, expectedError == apiError else {
                            fail("Error is not expected: \(error)")
                            return
                        }
                    }

                    context("redirect") {
                        it("returns .redirect") {
                            verify(statusCode: HttpStatusCode.redirect, returnsError: .redirect)
                        }
                    }

                    context("bad request") {
                        it("returns .badReques") {
                            verify(statusCode: HttpStatusCode.badRequest, returnsError: .badRequest)
                        }
                    }

                    context("internal server error") {
                        it("returns .serverError") {
                            verify(statusCode: HttpStatusCode.serverError, returnsError: .serverError)
                        }
                    }

                    context("down network") {
                        it("returns .network error") {
                            self.fakeDownNetwork(for: .categories)

                            let provider = CategoryProvider()
                            let result = provider
                                .fetchCategories(scheduler: MainScheduler.instance, retryOnError: false)
                                .toBlocking()
                                .materialize()

                            guard case let .failed(elements, error) = result else {
                                fail("Request should fail")
                                return
                            }

                            expect(elements).to(haveCount(0))

                            guard case APIError.network = error else {
                                fail("Error is not expected: \(error)")
                                return
                            }
                        }
                    }
                }

                context("request suceeds") {
                    it("parses and returns objects properly") {
                        self.fake(api: .categories, response: .fetchCategoriesSuccess)

                        let provider = CategoryProvider()
                        let result = provider
                            .fetchCategories(scheduler: MainScheduler.instance, retryOnError: false)
                            .toBlocking()
                            .materialize()

                        guard case .completed(let events) = result else {
                            fail("Search request didn't succeed")
                            return
                        }

                        expect(events).to(haveCount(1))

                        let returnedCategories = events[0].map { $0.name }
                        let expectedCategories = CategoryFactory.makeAllStringCategories()
                        expect(returnedCategories).to(equal(expectedCategories))
                    }
                }
            }
        }
    }
}
