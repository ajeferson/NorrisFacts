//
//  String+Common.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

extension String {
    func firstLetterCapitalized() -> String {
        prefix(1).capitalized + dropFirst()
    }
}
