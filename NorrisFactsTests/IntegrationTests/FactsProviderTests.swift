//
//  FactsProviderTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import OHHTTPStubs
import Quick
import Nimble
import RxBlocking
import RxSwift
@testable import NorrisFacts

final class FactsProviderTests: QuickSpec {
    override func spec() {
        describe("FactsProvider") {
            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("categories") {
                context("request fails") {
                    func verify(statusCode: Int, returnsError expectedError: APIError) {
                        self.fake(api: .categories, statusCode: statusCode)

                        let provider = FactsProvider()
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

                            let provider = FactsProvider()
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

            describe("serch") {
                context("request succeeds") {
                    it("returns parsed list of facts") {
                        let query = "north"
                        self.fake(api: .search(query: query), response: .searchSuccess)

                        let provider = FactsProvider()
                        let result = provider
                            .search(query: query)
                            .toBlocking()
                            .materialize()

                        guard case .completed(let events) = result else {
                            fail("Search request didn't succeed")
                            return
                        }

                        expect(events).to(haveCount(1))

                        let facts = events[0]
                        expect(facts).to(haveCount(2))

                        // Verify first fact
                        expect(facts[0].id).to(equal("dwxnerd8qamdgrzsl9aakq"))
                        expect(facts[0].iconUrl).to(equal("https://assets.chucknorris.host/img/avatar/chuck-norris.png"))
                        expect(facts[0].url).to(equal("https://api.chucknorris.io/jokes/dwxnerd8qamdgrzsl9aakq"))
                        expect(facts[0].categories).to(equal(["history", "career"]))
                        expect(facts[0].value).to(equal(
                            #"The term "Cleveland Steamer" got its name from Chuck Norris, "# +
                            "when he took a dump while visiting the Rock and Roll Hall of " +
                            "fame and buried northern Ohio under a glacier of fecal matter."
                        ))

                        // Verify second fact
                        expect(facts[1].id).to(equal("lr9litcitfmul3qjx_3mmw"))
                        expect(facts[1].iconUrl).to(equal("https://assets.chucknorris.host/img/avatar/chuck-norris.png"))
                        expect(facts[1].url).to(equal("https://api.chucknorris.io/jokes/lr9litcitfmul3qjx_3mmw"))
                        expect(facts[1].categories).to(equal(["political"]))
                        expect(facts[1].value).to(equal(
                            "Thousands of years ago Chuck Norris came across a bear. " +
                            "It was so terrified that it fled north into the arctic. " +
                            "It was also so terrified that all of its decendents now have white hair."
                        ))
                    }
                }
            }
        }
    }
}

// MARK: - Helper Methods

extension FactsProviderTests {
    private func condition(for api: FactsAPI) -> HTTPStubsTestBlock {
        let url = api.baseURL.appendingPathComponent(api.path)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        return isHost(components.host!) && isPath(components.path)
    }

    private func fake(api: FactsAPI, response: StubResponse? = nil, statusCode: Int = HttpStatusCode.success) {
        stub(condition: condition(for: api)) { _ in
            switch response {
            case .some(let response):
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile(response.filename, type(of: self))!,
                    statusCode: Int32(statusCode),
                    headers: [:]
                )
            case .none:
                return HTTPStubsResponse(data: Data(),
                                         statusCode: Int32(statusCode),
                                         headers: nil)
            }
        }
    }

    private func fakeDownNetwork(for api: FactsAPI) {
        stub(condition: condition(for: api)) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
            return HTTPStubsResponse(error: error)
        }
    }
}
