//
//  CategoryListViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct CategoryListViewModelInput {
    let loadCategories: Observable<Void>
    let categoryTap: Observable<String>
}

struct CategoryListViewModelOutput {
    let categories: Driver<[String]>
}

protocol CategoryListViewModelProtocol: TableViewSectionViewModelProtocol {
    var output: CategoryListViewModelOutput { get }

    func bind(input: CategoryListViewModelInput) -> Disposable
    func bind(searchViewModel viewModel: FactSearchViewModelProtocol) -> Disposable
}

final class CategoryListViewModel: CategoryListViewModelProtocol {
    private let categoryStore: CategoryStoreProtocol

    private let categoriesSubject = BehaviorRelay<[String]>(value: [])
    private let categoryTapSubject = PublishSubject<String>()

    var output: CategoryListViewModelOutput {
        .init(categories: categoriesSubject.asDriver())
    }

    private enum Constants {
        static let numberOfCategories = 8
    }

    var title: String {
        "Suggestions"
    }

    var numberOfItems: Int {
        1
    }

    init(categoryStore: CategoryStoreProtocol) {
        self.categoryStore = categoryStore
    }

    func bind(input: CategoryListViewModelInput) -> Disposable {
        Disposables.create(
            bindCategoryLoading(input),
            bindCategoryTap(input)
        )
    }

    func bind(searchViewModel viewModel: FactSearchViewModelProtocol) -> Disposable {
        viewModel.bind(categoryTap: categoryTapSubject)
    }

    private func bindCategoryTap(_ input: CategoryListViewModelInput) -> Disposable {
        input
            .categoryTap
            .bind(to: categoryTapSubject)
    }

    private func bindCategoryLoading(_ input: CategoryListViewModelInput) -> Disposable {
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
