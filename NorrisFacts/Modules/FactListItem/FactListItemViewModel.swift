//
//  FactListItemViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

struct FactListItemViewModel {
    // TODO: Make all Constants to have same styling
    private enum Constants {
        static let uncategorized = "Uncategorized"
        static let largeFontSize: CGFloat = 22
        static let smallFontSize: CGFloat = 16
        static let charactersThreshold = 80
    }

    let value: String
    let url: String
    let category: String
    let fontSize: CGFloat

    var shareableItems: [Any] {
        let shareableString = "\(value)\n\(url)"
        return [shareableString]
    }

    init(fact: Fact) {
        self.value = fact.value
        self.url = fact.url

        let category = fact.categories.first ?? Constants.uncategorized
        self.category = category.uppercased()

        if fact.value.count <= Constants.charactersThreshold {
            fontSize = Constants.largeFontSize
        } else {
            fontSize = Constants.smallFontSize
        }
    }
}
