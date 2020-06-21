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

    private let bag = DisposeBag()

    var viewModel: FactListViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModelInput()
        bindViewModelOutput()
    }

    private func setupView() {
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func bindViewModelInput() {
        let input = FactListViewModelInput(searchBarButtonTap: searchBarButton.rx.tap.asObservable())
        viewModel?
            .bind(input: input)
            .disposed(by: bag)
    }

    private func bindViewModelOutput() {
        guard let input = viewModel?.output else { return }

        let cellType = FactListItemTableViewCell.self
        input
            .items
            .drive(tableView.rx.items(cellIdentifier: cellType.id, cellType: cellType)) { _, itemViewModel, cell in
                cell.viewModel = itemViewModel
            }
            .disposed(by: bag)

        input
            .isShowingItems
            .map(!)
            .drive(tableView.rx.isHidden)
            .disposed(by: bag)

        input
            .message
            .drive(messageLabel.rx.text)
            .disposed(by: bag)
    }
}
