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
