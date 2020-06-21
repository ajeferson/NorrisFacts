//
//  RealmStore.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol RealmStore {}

extension RealmStore {
    func realm() -> Single<Realm> {
        Single.create { single -> Disposable in
            do {
                let realm = try Realm()
                single(.success(realm))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
