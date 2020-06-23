//
//  TagView.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class TagView: UIView {
    private enum Constants {
        static let fontSize: CGFloat = 16
        static let horizontalSpacing: CGFloat = 10
        static let verticalSpacing: CGFloat = 5
        static let cornerRadius: CGFloat = 3
    }

    var text: String = "" {
        didSet {
            let attributedTitle = buttonAttributedTitle(for: text)
            button.setAttributedTitle(attributedTitle, for: .normal)
        }
    }

    private lazy var button: UIButton = {
        let button = UIButton()
        let attributedTitle = buttonAttributedTitle(for: text)
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
        super.init(coder: coder)
        setup()
    }

    private func buttonAttributedTitle(for text: String) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [
            .font: UIFont.boldSystemFont(ofSize: Constants.fontSize),
            .foregroundColor: UIColor.white
        ])
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

        // Disable any previously set width constraints
        constraints
            .filter { $0.firstAttribute == .width }
            .forEach { $0.isActive = false }
    }
}
