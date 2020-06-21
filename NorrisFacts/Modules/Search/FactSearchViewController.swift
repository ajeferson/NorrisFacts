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
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let bag = DisposeBag()

    var viewModel: FactSearchViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModelInput()
        bindViewModelOutput()
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
    }
}
