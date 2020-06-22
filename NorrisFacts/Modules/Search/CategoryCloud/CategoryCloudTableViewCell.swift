//
//  CategoryCloudTableViewCell.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class CategoryCloudTableViewCell: UITableViewCell {
    @IBOutlet private weak var categoryCloudView: CategoryCloudView!
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint!
    private var bag = DisposeBag()

    func setup(with categoriesDriver: Driver<[String]>) {
        bag = DisposeBag()

        categoriesDriver
            .drive(onNext: { [weak self] categories in
                self?.addCategoryTags(for: categories)
            })
            .disposed(by: bag)
    }

    private func addCategoryTags(for categories: [String]) {
        let cloudViewWidth = UIScreen.main.bounds.width - leadingConstraint.constant - trailingConstraint.constant
        categoryCloudView.addTags(categories, width: cloudViewWidth)
    }
}
