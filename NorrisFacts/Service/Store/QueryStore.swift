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
    func getBy(name: String) -> Single<Query?>
    func save(query: Query, with facts: [Fact]) -> Completable
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

    func getBy(name: String) -> Single<Query?> {
        realm()
            .map { realm in
                realm.object(ofType: Query.self, forPrimaryKey: name)
            }
    }

    func save(query: Query, with facts: [Fact]) -> Completable {
        realm()
            .flatMapCompletable { realm -> Completable in
                realm.writeCompletable {
                    realm.add(facts, update: .modified)
                    query.facts.append(objectsIn: facts)
                    realm.add(query, update: .modified)
                }
            }
    }
}
