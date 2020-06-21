//
//  FactListCoordinator.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxSwift

protocol FactListCoordinatorProtocol: Coordinator {
    func startSearch()
}

final class FactListCoordinator: FactListCoordinatorProtocol {
    private let window: UIWindowProtocol
    private let storyboard: StoryboardProtocol
    private var navigationController: UINavigationController?
    private var searchCoordinator: FactSearchCoordinator?
    private var viewModel: FactListViewModel?

    init(window: UIWindowProtocol, storyboard: StoryboardProtocol) {
        self.window = window
        self.storyboard = storyboard
    }

    func start() {
        guard let viewController: FactListViewController = storyboard.instantiateViewController() else {
            return
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController

        let viewModel = FactListViewModel(coordinator: self)
        viewController.viewModel = viewModel
        self.viewModel = viewModel

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func startSearch() {
        guard let navigationController = navigationController else { return }

        searchCoordinator = FactSearchCoordinator(parent: navigationController, storyboard: storyboard) { [weak self] result in
            self?.searchCoordinator = nil
            self?.viewModel?.update(searchResult: result)
        }
        searchCoordinator?.start()
    }
}
