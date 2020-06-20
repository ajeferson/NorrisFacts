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

extension PrimitiveSequence where Trait == SingleTrait {
    func catchErrorReturnAPIError() -> PrimitiveSequence<Trait, Element> {
        catchError { error -> PrimitiveSequence<Trait, Element> in
            guard let moyaError = error as? MoyaError else {
                return .error(APIError.underlying(error))
            }

            if case .statusCode(let response) = moyaError {
                switch response.statusCode {
                case HttpStatusCode.redirect ..< HttpStatusCode.badRequest:
                    return .error(APIError.redirect)
                case HttpStatusCode.badRequest ..< HttpStatusCode.serverError:
                    return .error(APIError.badRequest)
                case HttpStatusCode.serverError...:
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
