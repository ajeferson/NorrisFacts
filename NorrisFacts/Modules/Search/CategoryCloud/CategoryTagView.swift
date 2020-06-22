//
//  CategoryTagView.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class CategoryTagView: UIView {
    private enum Constants {
        static let fontSize: CGFloat = 16
        static let horizontalSpacing: CGFloat = 10
        static let verticalSpacing: CGFloat = 5
        static let cornerRadius: CGFloat = 3
    }

    private let text: String
    private lazy var button: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: text, attributes: [
            .font: UIFont.boldSystemFont(ofSize: Constants.fontSize),
            .foregroundColor: UIColor.white
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var tap: ControlEvent<Void> {
        button.rx.tap
    }

    init(text: String) {
        self.text = text
        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .systemBlue
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalSpacing),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalSpacing),
            button.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalSpacing),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalSpacing)
        ])

        layer.cornerRadius = Constants.cornerRadius
    }
}
