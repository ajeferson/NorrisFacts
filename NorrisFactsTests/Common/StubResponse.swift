//
//  StubResponse.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
@testable import NorrisFacts

enum StubResponse: String {
    case searchSuccess

    var filename: String {
        "\(rawValue.firstLetterCapitalized())Response.json"
    }
}
