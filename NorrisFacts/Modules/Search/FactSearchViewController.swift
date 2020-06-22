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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = viewModel?.titleForSectionHeader(at: section) else {
            return nil
        }
        return TitleHeaderView(title: title)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CategoryListTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            fatalError("This ought to be impossible")
        }

        if let viewModel = viewModel {
            let categoryListViewModel = viewModel.makeCategoryListViewModel()
            categoryListViewModel
                .bind(searchViewModel: viewModel)
                .disposed(by: bag)
            cell.viewModel = categoryListViewModel
        }

        return cell
    }
}
