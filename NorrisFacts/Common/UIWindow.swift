//
//  UIWindow.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

protocol UIWindowProtocol: AnyObject {
    var rootViewController: UIViewController? { get set }
    func makeKeyAndVisible()
}

extension UIWindow: UIWindowProtocol {}
