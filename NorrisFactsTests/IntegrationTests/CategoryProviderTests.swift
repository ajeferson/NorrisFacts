//
//  CategoryProviderTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import NorrisFacts

final class CategoryProviderTests: QuickSpec {
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
                            .fetchCategories()
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
                                .fetchCategories()
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
            }
        }
    }
}

extension CategoryProviderTests: ProviderTests {}
