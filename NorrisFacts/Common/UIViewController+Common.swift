//
//  UIViewController+Common.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(error: ErrorDescriptor) {
        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func share(items: [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceRect = .zero
        present(activityController, animated: true, completion: nil)
    }
}
