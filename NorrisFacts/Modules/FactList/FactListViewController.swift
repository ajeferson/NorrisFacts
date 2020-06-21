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

    private let bag = DisposeBag()

    var viewModel: FactListViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModelInput()
    }

    private func bindViewModelInput() {
        let input = FactListViewModelInput(searchBarButtonTap: searchBarButton.rx.tap.asObservable())
        viewModel?
            .bind(input: input)
            .disposed(by: bag)
    }
}
