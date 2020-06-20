//
//  SearchViewController.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!

    private let viewModel: SearchViewModelProtocol = SearchViewModel()
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModelInput()
    }

    private func bindViewModelInput() {
        let input = SearchViewModelInput(
            searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
            searchText: searchBar.rx.text.asObservable()
        )

        viewModel
            .bind(input: input)
            .disposed(by: bag)
    }
}
