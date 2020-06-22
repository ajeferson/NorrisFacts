//
//  UITableView+Common.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: T.id, for: indexPath) as? T
    }
}
