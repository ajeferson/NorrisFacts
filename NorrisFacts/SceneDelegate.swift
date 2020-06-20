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
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
