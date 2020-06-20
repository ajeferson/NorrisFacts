//
//  PrimitiveSequence+API.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import Moya
import RxSwift

private enum HttpStatusRanges {
    static let redirect = 300..<400
    static let badRequest = 400..<500
    static let serverError = 500..<600
}

extension PrimitiveSequence where Trait == SingleTrait {
    func catchErrorReturnAPIError() -> PrimitiveSequence<Trait, Element> {
        catchError { error -> PrimitiveSequence<Trait, Element> in
            guard let moyaError = error as? MoyaError else {
                return .error(APIError.underlying(error))
            }

            if case .statusCode(let response) = moyaError {
                switch response.statusCode {
                case HttpStatusRanges.redirect:
                    return .error(APIError.redirect)
                case HttpStatusRanges.badRequest:
                    return .error(APIError.badRequest)
                case HttpStatusRanges.serverError:
                    return .error(APIError.serverError)
                default:
                    return .error(APIError.unknown)
                }
            }

            guard case let .underlying(underlyingError, _) = moyaError, let afError = underlyingError.asAFError else {
                return .error(APIError.underlying(moyaError))
            }

            if case .sessionTaskFailed = afError {
                return .error(APIError.network)
            }

            return .error(APIError.underlying(afError))
        }
    }
}
