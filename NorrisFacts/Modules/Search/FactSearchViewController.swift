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
        bindViewModelToCategoryTap()
        bindViewModelToQueryTap()
        bindViewModelOutput()
    }

    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func bindViewModelInput() {
        guard let viewModel = viewModel else { return }

        let input = FactSearchViewModelInput(
            cancelButtonClicked: cancelBarButton.rx.tap.asObservable(),
            searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
            searchText: searchBar.rx.text.asObservable()
        )

        viewModel
            .bind(input: input)
            .disposed(by: bag)

        let searchHistoryInput = SearchHistoryViewModelInput(
            loadQueries: .just(())
        )

        let searchHistoryViewModel = viewModel.searchHistoryViewModel
        searchHistoryViewModel
            .bind(input: searchHistoryInput)
            .disposed(by: bag)

        let queryTap = searchHistoryViewModel
            .output
            .queryTap
            .asObservable()

        viewModel
            .bind(queryTap: queryTap)
            .disposed(by: bag)
    }

    private func bindViewModelToCategoryTap() {
        guard let viewModel = viewModel else { return }

        let categoryListViewModel = viewModel.categoryListViewModel
        let categoryTap = categoryListViewModel.output.categoryTap.asObservable()

        viewModel
            .bind(categoryTap: categoryTap)
            .disposed(by: bag)
    }

    private func bindViewModelToQueryTap() {
        guard let viewModel = viewModel else { return }

        let searchHistoryViewModel = viewModel.searchHistoryViewModel

        let queryTap = searchHistoryViewModel
            .output
            .queryTap
            .asObservable()

        viewModel
            .bind(queryTap: queryTap)
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

        output
            .isLoading
            .drive(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: bag)
    }
}

extension FactSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionViewModel = viewModel?.sectionViewModel(at: section) else {
            return nil
        }
        return TitleHeaderView(title: sectionViewModel.title)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionViewModel = viewModel?.sectionViewModel(at: section) else {
            return 0
        }
        return sectionViewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionViewModel = viewModel?.sectionViewModel(at: indexPath.section) else {
            return UITableViewCell()
        }

        switch sectionViewModel {
        case is CategoryListViewModel:
            return makeCategoryListTableViewCell(for: indexPath)
        case is SearchHistoryViewModel:
            return makeSearchHistoryItemTableViewCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let sectionViewModel = viewModel?.sectionViewModel(at: indexPath.section) else {
            return
        }
        sectionViewModel.didSelectRow(at: indexPath.row)
    }

    private func makeCategoryListTableViewCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CategoryListTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            fatalError("This ought to be impossible")
        }
        cell.viewModel = viewModel?.categoryListViewModel
        return cell
    }

    private func makeSearchHistoryItemTableViewCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchHistoryItemTableViewCell = tableView.dequeueReusableCell(for: indexPath),
            let viewModel = viewModel else {
                fatalError("This ought to be impossible")
        }

        let searchHistoryViewModel = viewModel.searchHistoryViewModel
        cell.query = searchHistoryViewModel.item(for: indexPath.row)

        return cell
    }
}
