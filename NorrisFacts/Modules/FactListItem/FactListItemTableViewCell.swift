//
//  FactListItemTableViewCell.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

final class FactListItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var tagView: TagView!

    var viewModel: FactListItemViewModel? {
        didSet {
            updateView()
        }
    }

    private func updateView() {
        guard let viewModel = viewModel else { return }

        valueLabel.text = viewModel.value
        tagView.text = viewModel.category
    }
}
