//
//  CategoryProvider.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

protocol CategoryProviderProtocol {
    func fetchCategories(scheduler: SchedulerType, retryOnError: Bool) -> Single<[Category]>
}

struct CategoryProvider: CategoryProviderProtocol {
    private let provider = MoyaProvider<ChuckNorrisAPI>()

    func fetchCategories(scheduler: SchedulerType, retryOnError: Bool) -> Single<[Category]> {
        let result = provider
            .rx
            .request(.categories)
            .filterSuccessfulStatusCodes()
            .map([String].self)
            .map { $0.map { Category(name: $0) } }
            .catchErrorReturnAPIError()

        if retryOnError {
            return result.retryWhenNetworkOrServerError(scheduler: scheduler)
        }
        return result
    }
}
