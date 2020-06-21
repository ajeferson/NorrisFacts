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
    func fetchCategories() -> Single<[String]>
}

struct CategoryProvider: CategoryProviderProtocol {
    private let provider = MoyaProvider<FactsAPI>()

    func fetchCategories() -> Single<[String]> {
        provider
            .rx
            .request(.categories)
            .filterSuccessfulStatusCodes()
            .map([String].self)
            .catchErrorReturnAPIError()
    }
}
