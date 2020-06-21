//
//  ErrorDescriptor.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

struct ErrorDescriptor {
    let id: Int
    let message: String

    var title: String {
        "Error #\(id)"
    }

    static var general: ErrorDescriptor {
        .init(id: 1, message: "An unexpected error just occurred, please try again later")
    }

    static var server: ErrorDescriptor {
        .init(id: 2, message: "Failed to connect to server, please try again later")
    }

    static var network: ErrorDescriptor {
        .init(id: 3, message: "Please check your internet connection")
    }
}
