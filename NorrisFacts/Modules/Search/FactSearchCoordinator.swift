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
    func finish(query: String?)
}

final class FactSearchCoordinator: FactSearchCoordinatorProtocol {
    private let parent: UIViewController
    private var navigationController: UINavigationController?
    private let storyboard: StoryboardProtocol
    private let finishHandler: (String?) -> Void

    init(parent: UIViewController, storyboard: StoryboardProtocol, onFinish finishHandler: @escaping (String?) -> Void) {
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

        let viewModel = FactSearchViewModel(coordinator: self)
        viewController.viewModel = viewModel

        parent.present(navigationController, animated: true, completion: nil)
    }

    func finish(query: String?) {
        navigationController?.dismiss(animated: true) { [weak self] in
            self?.finishHandler(query)
        }
    }
}
