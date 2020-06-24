//
//  CategoryCachingWorkflow.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

protocol Workflow {
    func start()
}

final class CategoryCachingWorkflow: Workflow {
    private let manager: CategoryManagerProtocol
    private let bag = DisposeBag()

    init() {
        manager = CategoryManager(provider: CategoryProvider(),
                                  store: CategoryStore(),
                                  scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    func start() {
        manager
            .cacheCategoriesIfNeeded()
            .subscribe()
            .disposed(by: bag)
    }
}
