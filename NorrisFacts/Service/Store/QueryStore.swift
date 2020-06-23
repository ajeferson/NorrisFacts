//
//  QueryStore.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol QueryStoreProtocol: RealmStore {
    func all(limit: Int) -> Single<[Query]>
    func save(query: Query) -> Completable
}

final class QueryStore: QueryStoreProtocol {
    func all(limit: Int) -> Single<[Query]> {
        realm()
            .map { realm in
                realm
                    .objects(Query.self)
                    .sorted(byKeyPath: Query.Keys.updatedAt, ascending: false)
            }
            .map { Array($0.prefix(limit)) }
    }

    func save(query: Query) -> Completable {
        realm()
            .flatMapCompletable { realm -> Completable in
                realm.writeCompletable {
                    realm.add(query, update: .modified)
                }
            }
    }
}
