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

struct SearchCategoriesViewModelInput {
    let loadCategories: Observable<Void>
    let categoryTap: Observable<String>
}

struct SearchCategoriesViewModelOutput {
    let categories: Driver<[String]>
}

protocol SearchCategoriesViewModelProtocol {
    var output: SearchCategoriesViewModelOutput { get }

    func bind(input: SearchCategoriesViewModelInput) -> Disposable
    func bind(searchViewModel viewModel: FactSearchViewModelProtocol) -> Disposable
}

final class SearchCategoriesViewModel: SearchCategoriesViewModelProtocol {
    private let categoryStore: CategoryStoreProtocol

    private let categoriesSubject = BehaviorRelay<[String]>(value: [])
    private let categoryTapSubject = PublishSubject<String>()

    var output: SearchCategoriesViewModelOutput {
        .init(categories: categoriesSubject.asDriver())
    }

    private enum Constants {
        static let numberOfCategories = 8
    }

    init(categoryStore: CategoryStoreProtocol) {
        self.categoryStore = categoryStore
    }

    func bind(input: SearchCategoriesViewModelInput) -> Disposable {
        Disposables.create(
            bindCategoryLoading(input),
            bindCategoryTap(input)
        )
    }

    func bind(searchViewModel viewModel: FactSearchViewModelProtocol) -> Disposable {
        viewModel.bind(categoryTap: categoryTapSubject)
    }

    private func bindCategoryTap(_ input: SearchCategoriesViewModelInput) -> Disposable {
        input
            .categoryTap
            .bind(to: categoryTapSubject)
    }

    private func bindCategoryLoading(_ input: SearchCategoriesViewModelInput) -> Disposable {
        input
            .loadCategories
            .flatMap { [weak self] _ -> Observable<[Category]> in
                guard let self = self else {
                    return .empty()
                }
                return self.categoryStore.all().asObservable()
            }
            .map { $0.map { $0.name.uppercased() } }
            .map { $0.shuffled() }
            .map { Array($0[..<Constants.numberOfCategories]) }
            .bind(to: categoriesSubject)
    }
}

// TODO: Totally rename this
final class CategoryCloudTableViewCell: UITableViewCell {
    @IBOutlet private weak var categoryCloudView: CategoryCloudView!
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint!
    private var bag = DisposeBag()

    var viewModel: SearchCategoriesViewModelProtocol? = SearchCategoriesViewModel(categoryStore: CategoryStore())

    func setup() {
        // Dispose of previous subscriptions
        bag = DisposeBag()

        bindViewModelInput()
        bindViewModelOutput()
    }

    private func bindViewModelInput() {
        let input = SearchCategoriesViewModelInput(
            loadCategories: .just(()),
            categoryTap: categoryCloudView.tagTap
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
        categoryCloudView.addTags(categories, width: cloudViewWidth)
    }
}
