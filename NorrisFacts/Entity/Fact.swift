//
//  Fact.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

struct Fact: Decodable {
    let id: String
    let url: String
    let value: String
    let iconUrl: String
    let categories: [String]
}

extension Fact: Equatable {}
