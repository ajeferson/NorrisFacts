//
//  IdentifiableType.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

protocol IdentifiableType {
    static var id: String { get }
}

extension IdentifiableType {
    static var id: String {
        String(describing: self)
    }
}

extension UIViewController: IdentifiableType {}
