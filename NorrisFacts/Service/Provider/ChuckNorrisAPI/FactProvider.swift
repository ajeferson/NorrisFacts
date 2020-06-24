//
//  FactProvider.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/19/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

protocol FactProviderProtocol {
    func search(query: String, scheduler: SchedulerType) -> Single<[Fact]>
}

struct FactProvider: FactProviderProtocol {
    private let provider = MoyaProvider<ChuckNorrisAPI>()

    func search(query: String, scheduler: SchedulerType) -> Single<[Fact]> {
        provider
            .rx
            .request(.search(query: query))
            .filterSuccessfulStatusCodes()
            .map(FactListResult.self, using: .default, failsOnEmptyData: true)
            .map { $0.result }
            .catchErrorReturnAPIError()
            .retryWhenNetworkOrServerError(scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

private extension FactProvider {
    struct FactListResult: Decodable {
        let total: Int
        let result: [Fact]
    }
}
