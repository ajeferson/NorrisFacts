//
//  Query.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RealmSwift

final class Query: Object {
    @objc dynamic var name = ""
    @objc dynamic var updatedAt = Date()
    let facts = List<Fact>()

    enum Keys {
        static let name = "name"
        static let updatedAt = "updatedAt"
    }

    override class func primaryKey() -> String? {
        return Keys.name
    }

    required init() {
        self.name = ""
        super.init()
    }

    init(name: String) {
        self.name = name
    }
}
