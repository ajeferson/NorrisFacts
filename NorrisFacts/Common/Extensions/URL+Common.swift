//
//  URL+Common.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

extension URL {
    init(staticString: StaticString) {
        // Force unwrapping will be fine here because StaticString
        // can only be used at BuildTime
        //swiftlint:disable:next force_unwrapping
        self.init(string: "\(staticString)")!
    }
}
