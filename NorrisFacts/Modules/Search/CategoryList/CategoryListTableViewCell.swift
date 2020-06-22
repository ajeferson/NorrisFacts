//
//  CategoryListTableViewCell.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct CategoryListViewModelInput {
    let loadCategories: Observable<Void>
    let categoryTap: Observable<String>
}

struct CategoryListViewModelOutput {
    let categories: Driver<[String]>
}

final class CategoryListTableViewCell: UITableViewCell {
    @IBOutlet private weak var tagListView: TagListView!
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint!

    private var bag = DisposeBag()

    var viewModel: CategoryListViewModelProtocol? {
        didSet {
            setup()
        }
    }

    func setup() {
        bag = DisposeBag()

        bindViewModelInput()
        bindViewModelOutput()
    }

    private func bindViewModelInput() {
        let input = CategoryListViewModelInput(
            loadCategories: .just(()),
            categoryTap: tagListView.tagTap
        )

        viewModel?
            .bind(input: input)
            .disposed(by: bag)
    }

    private func bindViewModelOutput() {
        guard let output = viewModel?.output else { return }

        output
            .categories
            .drive(onNext: { [weak self] categories in
                self?.addCategoryTags(for: categories)
            })
            .disposed(by: bag)
    }

    private func addCategoryTags(for categories: [String]) {
        let cloudViewWidth = UIScreen.main.bounds.width - leadingConstraint.constant - trailingConstraint.constant
        tagListView.addTags(categories, width: cloudViewWidth)
    }
}
