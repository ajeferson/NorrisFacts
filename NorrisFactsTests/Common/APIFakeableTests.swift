//
//  APIFakeableTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import OHHTTPStubs
@testable import NorrisFacts

protocol APIFakeableTests {}

extension APIFakeableTests {
    func condition(for api: ChuckNorrisAPI) -> HTTPStubsTestBlock {
        let url = api.baseURL.appendingPathComponent(api.path)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        return isHost(components.host!) && isPath(components.path)
    }

    func fake(api: ChuckNorrisAPI, response: StubResponse? = nil, statusCode: Int = HttpStatusCode.success) {
        stub(condition: condition(for: api)) { _ in
            switch response {
            case .some(let response):
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile(response.filename, CategoryProviderTests.self)!,
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

    func fakeDownNetwork(for api: ChuckNorrisAPI) {
        stub(condition: condition(for: api)) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
            return HTTPStubsResponse(error: error)
        }
    }
}
