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
    func fetchCategories() -> Single<[Category]>
}

struct CategoryProvider: CategoryProviderProtocol {
    private let provider = MoyaProvider<ChuckNorrisAPI>()

    func fetchCategories() -> Single<[Category]> {
        provider
            .rx
            .request(.categories)
            .filterSuccessfulStatusCodes()
            .map([String].self)
            .map { $0.map { Category(name: $0) } }
            .catchErrorReturnAPIError()
    }
}
