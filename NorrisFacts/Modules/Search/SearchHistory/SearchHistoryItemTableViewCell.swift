//
//  SearchHistoryItemTableViewCell.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

final class SearchHistoryItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var queryLabel: UILabel!

    var query: String? {
        didSet {
            queryLabel.text = query
        }
    }
}
