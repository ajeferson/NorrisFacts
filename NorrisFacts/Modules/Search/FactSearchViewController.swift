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

    private let viewModel: FactSearchViewModelProtocol = FactSearchViewModel()
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModelInput()
    }

    private func bindViewModelInput() {
        let input = FactSearchViewModelInput(
            searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
            searchText: searchBar.rx.text.asObservable()
        )

        viewModel
            .bind(input: input)
            .disposed(by: bag)
    }
}
