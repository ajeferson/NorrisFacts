//
//  FactsAPI.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/19/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import Moya

enum FactsAPI: TargetType {
    case categories
    case search(query: String)

    private enum QueryParameterKey: String {
        case query
    }

    var baseURL: URL {
        return URL(staticString: "https://api.chucknorris.io/jokes")
    }

    var path: String {
        switch self {
        case .categories:
            return "categories"
        case .search:
            return "search"
        }
    }

    var method: Moya.Method {
        .get
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
        case .categories:
            return .requestPlain
        case .search(let query):
            let parameters = [QueryParameterKey.query.rawValue: query]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        nil
    }
}
