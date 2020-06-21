//
//  FactSearchCoordinator.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import RxSwift

protocol FactSearchCoordinatorProtocol: Coordinator {
    func finish(facts: [Fact]?)
}

final class FactSearchCoordinator: FactSearchCoordinatorProtocol {
    private let parent: UIViewController
    private var navigationController: UINavigationController?
    private let storyboard: StoryboardProtocol
    private let finishHandler: ([Fact]?) -> Void

    init(parent: UIViewController, storyboard: StoryboardProtocol, onFinish finishHandler: @escaping ([Fact]?) -> Void) {
        self.parent = parent
        self.storyboard = storyboard
        self.finishHandler = finishHandler
    }

    func start() {
        guard let viewController: FactSearchViewController = storyboard.instantiateViewController() else {
            return
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController = navigationController

        let factsProvider = FactsProvider()
        let viewModel = FactSearchViewModel(coordinator: self, factsProvider: factsProvider)
        viewController.viewModel = viewModel

        parent.present(navigationController, animated: true, completion: nil)
    }

    func finish(facts: [Fact]?) {
        navigationController?.dismiss(animated: true) { [weak self] in
            self?.finishHandler(facts)
        }
    }
}
