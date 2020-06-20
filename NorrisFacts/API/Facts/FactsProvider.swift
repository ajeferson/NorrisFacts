//
//  FactsProvider.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/19/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

protocol FactsProviderProtocol {
    func search(query: String) -> Single<[Fact]>
    func fetchCategories() -> Single<[String]>
}

struct FactsProvider {
    private let provider = MoyaProvider<FactsAPI>()

    func search(query: String) -> Single<[Fact]> {
        provider
            .rx
            .request(.search(query: query))
            .filterSuccessfulStatusCodes()
            .map(FactListResult.self, using: .default, failsOnEmptyData: true)
            .map { $0.result }
            .catchErrorReturnAPIError()
    }

    func fetchCategories() -> Single<[String]> {
        provider
            .rx
            .request(.categories)
            .filterSuccessfulStatusCodes()
            .map([String].self)
            .catchErrorReturnAPIError()
    }
}

private extension FactsProvider {
    struct FactListResult: Decodable {
        let total: Int
        let result: [Fact]
    }
}
