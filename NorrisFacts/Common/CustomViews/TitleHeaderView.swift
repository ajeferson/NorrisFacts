//
//  TitleHeaderView.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

final class TitleHeaderView: UIView {
    private enum Constants {
        static let fontSize: CGFloat = 17
        static let leadingSpacing: CGFloat = 16
    }

    init(title: String) {
        super.init(frame: .zero)
        setup(with: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(with title: String) {
        backgroundColor = .systemBackground

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.fontSize)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
