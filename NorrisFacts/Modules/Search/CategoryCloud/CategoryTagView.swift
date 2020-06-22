//
//  CategoryTagView.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

final class CategoryTagView: UIView {
    private enum Constants {
        static let fontSize: CGFloat = 17
        static let horizontalSpacing: CGFloat = 12
        static let verticalSpacing: CGFloat = 6
        static let cornerRadius: CGFloat = 3
    }

    init(text: String) {
        super.init(frame: .zero)
        setup(with: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(with text: String) {
        backgroundColor = .systemBlue
        translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Constants.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalSpacing),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalSpacing),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalSpacing),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalSpacing)
        ])

        layer.cornerRadius = Constants.cornerRadius
    }
}
