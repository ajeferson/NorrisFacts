//
//  FactListCoordinator.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

final class FactListCoordinator: Coordinator {
    private let window: UIWindowProtocol
    private let storyboard: StoryboardProtocol

    init(window: UIWindowProtocol, storyboard: StoryboardProtocol) {
        self.window = window
        self.storyboard = storyboard
    }

    func start() {
        guard let viewController: FactListViewController = storyboard.instantiateViewController() else {
            return
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        let viewModel = FactListViewModel()
        viewController.viewModel = viewModel

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
