//
//  APIError.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

enum APIError: Error {
    case badRequest
    case network
    case redirect
    case serverError
    case underlying(Error)
    case unknown
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.badRequest, .badRequest): return true
        case (.network, .network): return true
        case (.redirect, .redirect): return true
        case (.serverError, .serverError): return true
        case (.underlying, .underlying): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}
