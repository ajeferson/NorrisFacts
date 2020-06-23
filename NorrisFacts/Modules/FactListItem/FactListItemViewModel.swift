//
//  FactListItemViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

struct FactListItemViewModel {
    let value: String
    let category: String

    private enum Constants {
        static let uncategorized = "Uncategorized"
    }

    init(fact: Fact) {
        self.value = fact.value

        let category = fact.categories.first ?? Constants.uncategorized
        self.category = category.uppercased()
    }
}
