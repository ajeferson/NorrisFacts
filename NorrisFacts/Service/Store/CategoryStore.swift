//
//  CategoryStore.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

protocol CategoryStoreProtocol: RealmStore {}

final class CategoryStore: CategoryStoreProtocol {
    func all() -> Single<[Category]> {
        realm()
            .map { $0.objects(Category.self) }
            .map { Array($0) }
    }

    func save(categories: [Category]) -> Completable {
        realm()
            .flatMapCompletable { realm -> Completable in
                realm.writeCompletable {
                    realm.add(categories)
                }
            }
    }
}
