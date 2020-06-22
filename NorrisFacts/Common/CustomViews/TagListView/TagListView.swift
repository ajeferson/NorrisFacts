//
//  TagListView.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxSwift

final class TagListView: UIView {
    private let spacing: CGFloat = 10
    private var tagsAdded = false
    private lazy var horizontalStack = makeHorizontalStack()

    private lazy var verticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        verticalStack.distribution = .fill
        verticalStack.spacing = spacing
        verticalStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(verticalStack)

        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            verticalStack.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])

        return verticalStack
    }()

    private func makeHorizontalStack() -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .top
        horizontalStack.distribution = .fill
        horizontalStack.spacing = spacing
        verticalStack.addArrangedSubview(horizontalStack)
        return horizontalStack
    }

    private let bag = DisposeBag()
    private let tagTapSubject = PublishSubject<String>()
    var tagTap: Observable<String> {
        tagTapSubject
    }

    func addTags(_ tags: [String], width: CGFloat) {
        guard !tagsAdded else {
            return
        }
        tagsAdded = true

        let initialWidth = width
        var accumulatedWidth: CGFloat = 0

        tags.forEach { tag in
            let tagView = TagView(text: tag)
            tagView.layoutIfNeeded()

            let tagWidth = tagView.frame.size.width
            let spacedWidth = tagWidth + spacing
            let remainingWidth = initialWidth - accumulatedWidth

            if tagWidth > initialWidth {
                horizontalStack.addArrangedSubview(tagView)
                horizontalStack = makeHorizontalStack()
                accumulatedWidth = 0
            } else {
                if spacedWidth > remainingWidth {
                    horizontalStack = makeHorizontalStack()
                    accumulatedWidth = 0
                }
                horizontalStack.addArrangedSubview(tagView)
                accumulatedWidth += spacedWidth
            }

            tagView.tap
                .map { tag }
                .bind(to: tagTapSubject)
                .disposed(by: bag)
        }
    }
}
