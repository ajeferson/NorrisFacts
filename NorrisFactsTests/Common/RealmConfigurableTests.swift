//
//  RealmConfigurableTests.swift
//  NorrisFactsTests
//
//  Created by Alan Paiva on 6/24/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmConfigurableTests {
    func configureInMemoryTestableRealmInstance()
}

extension RealmConfigurableTests {
    func configureInMemoryTestableRealmInstance() {
        let inMemoryIdentifier = "TestInstanceRealm"
        let configuration = Realm.Configuration(inMemoryIdentifier: inMemoryIdentifier)
        Realm.Configuration.defaultConfiguration = configuration
    }
}
