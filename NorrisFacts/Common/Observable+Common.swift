//
//  Observable+Common.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/21/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func mapToResult() -> Observable<Result<Element, Error>> {
        map { .success($0) }
            .catchError { error -> Observable<Result<Element, Error>> in
                .just(.failure(error))
            }
    }
}
