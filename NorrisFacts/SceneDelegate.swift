//
//  SceneDelegate.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/18/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var coordinator: FactListCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        coordinator = FactListCoordinator(window: window, storyboard: Storyboard.main)
        coordinator?.start()
    }
}
