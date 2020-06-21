//
//  Storyboard.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

protocol StoryboardProtocol {
    func instantiateViewController<T: IdentifiableType>() -> T?
}

enum Storyboard: String, StoryboardProtocol {
    case main

    func instantiateViewController<T: IdentifiableType>() -> T? {
        let storyboard = UIStoryboard(name: rawValue.firstLetterCapitalized(), bundle: nil)
        return storyboard.instantiateViewController(identifier: T.id) as? T
    }
}
