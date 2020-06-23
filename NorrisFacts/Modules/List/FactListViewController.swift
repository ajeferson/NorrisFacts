//
//  FactListViewController.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class FactListViewController: UIViewController {
    @IBOutlet private weak var searchBarButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageLabel: UILabel!

    private var isSetup = false
    private let bag = DisposeBag()

    var viewModel: FactListViewModelProtocol?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard !isSetup else { return }
        isSetup = true

        setupView()
        bindViewModelInput()
        bindViewModelOutput()
    }

    private func setupView() {
        tableView.tableFooterView = UIView(frame: .zero)

        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }

    private func bindViewModelInput() {
        let input = FactListViewModelInput(
            searchBarButtonTap: searchBarButton.rx.tap.asObservable(),
            factTap: tableView.rx.itemSelected.map { $0.row }
        )

        viewModel?
            .bind(input: input)
            .disposed(by: bag)
    }

    private func bindViewModelOutput() {
        guard let output = viewModel?.output else { return }

        let cellType = FactListItemTableViewCell.self
        output
            .items
            .drive(tableView.rx.items(cellIdentifier: cellType.id, cellType: cellType)) { _, itemViewModel, cell in
                cell.viewModel = itemViewModel
            }
            .disposed(by: bag)

        output
            .isShowingItems
            .map(!)
            .drive(tableView.rx.isHidden)
            .disposed(by: bag)

        output
            .message
            .drive(messageLabel.rx.text)
            .disposed(by: bag)

        output
            .sharedItems
            .drive(onNext: { [weak self] items in
                self?.share(items: items)
            })
            .disposed(by: bag)
    }
}
