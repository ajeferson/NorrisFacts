//
//  FactSearchCoordinator.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

final class FactSearchCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let storyboard: StoryboardProtocol

    init(navigationController: UINavigationController, storyboard: StoryboardProtocol) {
        self.navigationController = navigationController
        self.storyboard = storyboard
    }

    func start() {
        guard let viewController: FactSearchViewController = storyboard.instantiateViewController() else {
            return
        }

        let viewModel = FactSearchViewModel()
        viewController.viewModel = viewModel
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
