//
//  FactSearchViewController.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class FactSearchViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let bag = DisposeBag()

    var viewModel: FactSearchViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModelInput()
        bindViewModelOutput()
    }

    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func bindViewModelInput() {
        let input = FactSearchViewModelInput(
            cancelButtonClicked: cancelBarButton.rx.tap.asObservable(),
            searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
            searchText: searchBar.rx.text.asObservable()
        )

        viewModel?
            .bind(input: input)
            .disposed(by: bag)
    }

    private func bindViewModelOutput() {
        guard let output = viewModel?.output else { return }

        output
            .isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)

        output
            .isLoading
            .map(!)
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: bag)

        output
            .error
            .drive(onNext: { [weak self] error in
                self?.alert(error: error)
            })
            .disposed(by: bag)

        output
            .isLoading
            .drive(tableView.rx.isHidden)
            .disposed(by: bag)
    }
}

extension FactSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = sectionViewModel(for: section) else {
            return nil
        }
        return TitleHeaderView(title: viewModel.title)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = sectionViewModel(for: section) else {
            return 0
        }
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = FactSearchTableViewSection(rawValue: indexPath.section) else {
            fatalError("Table view is improperly setup")
        }

        switch section {
        case .categoryList:
            return makeCategoryListTableViewCell(for: indexPath)
        case .searchHistory:
            return makeSearchHistoryItemTableViewCell(for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func sectionViewModel(for index: Int) -> TableViewSectionViewModelProtocol? {
        guard let section = FactSearchTableViewSection(rawValue: index), let viewModel = viewModel else {
            return nil
        }
        switch section {
        case .categoryList:
            return viewModel.categoryListViewModel()
        case .searchHistory:
            return viewModel.searchHistoryViewModel()
        }
    }

    private func makeCategoryListTableViewCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CategoryListTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            fatalError("This ought to be impossible")
        }

        if let viewModel = viewModel {
            let categoryListViewModel = viewModel.categoryListViewModel()
            categoryListViewModel
                .bind(searchViewModel: viewModel)
                .disposed(by: bag)
            cell.viewModel = categoryListViewModel
        }

        return cell
    }

    private func makeSearchHistoryItemTableViewCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchHistoryItemTableViewCell = tableView.dequeueReusableCell(for: indexPath),
            let viewModel = viewModel else {
                fatalError("This ought to be impossible")
        }

        let searchHistoryViewModel = viewModel.searchHistoryViewModel()
        cell.query = searchHistoryViewModel.item(for: indexPath.row)

        return cell
    }
}
