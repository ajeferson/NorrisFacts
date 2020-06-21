//
//  Result+Common.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

extension Result {
    func getError() -> Failure? {
        guard case let .failure(error) = self else {
            return nil
        }
        return error
    }
}
