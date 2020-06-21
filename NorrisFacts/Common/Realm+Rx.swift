//
//  Realm+Rx.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

extension Realm {
    func writeCompletable(_ block: @escaping () throws -> Void) -> Completable {
        Completable.create { completable -> Disposable in
            do {
                try self.write(block)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
