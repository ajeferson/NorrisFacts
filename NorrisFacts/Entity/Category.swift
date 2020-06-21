//
//  Category.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RealmSwift

final class Category: Object {
    @objc dynamic var name: String

    required init() {
        self.name = ""
        super.init()
    }

    init(name: String) {
        self.name = name
    }
}
