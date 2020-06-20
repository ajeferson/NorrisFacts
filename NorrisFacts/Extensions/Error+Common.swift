//
//  Error+Common.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

extension Error {
    var code: Int {
        (self as NSError).code
    }
}
