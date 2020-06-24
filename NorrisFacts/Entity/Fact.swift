//
//  Fact.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RealmSwift

final class Fact: Object, Decodable {
    @objc dynamic var id = ""
    @objc dynamic var url = ""
    @objc dynamic var value = ""
    @objc dynamic var iconUrl = ""
    let categories = List<String>()

    override class func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: CodingKey {
        case id
        case url
        case value
        case iconUrl
        case categories
    }

    required init() {
        super.init()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        value = try container.decode(String.self, forKey: .value)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        let categories = try container.decode([String].self, forKey: .categories)
        self.categories.append(objectsIn: categories)
    }
}
