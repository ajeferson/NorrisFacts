//
//  CategoryFactory.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
@testable import NorrisFacts

struct CategoryFactory {
    static func makeAllStringCategories() -> [String] {
        let decoder = JSONDecoder()
        let filename = StubResponse.fetchCategoriesSuccess.filename
        let bundle = Bundle(for: CategoryListViewModelTests.self)
        let url = bundle.url(forResource: filename, withExtension: nil)!
        let data = try! Data(contentsOf: url)
        return try! decoder.decode([String].self, from: data)
    }

    static func makeAllCategories() -> [NorrisFacts.Category] {
        makeAllStringCategories().map { .init(name: $0) }
    }
}
