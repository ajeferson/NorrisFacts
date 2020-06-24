//
//  PrimitiveSequence+Common.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/23/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait {
    func delayRetry(
        scheduler: SchedulerType,
        delayFunction: @escaping (Int, Error) -> Int) -> PrimitiveSequence<SingleTrait, Element> {
        retryWhen { notifier -> Observable<Void> in
            notifier.enumerated().flatMap { index, error -> Observable<Void> in
                let delay = delayFunction(index, error)
                if delay >= 0 {
                    return Observable<Void>
                        .just(())
                        .delay(.seconds(delay), scheduler: scheduler)
                }
                return .error(error)
            }
        }
    }
}

extension PrimitiveSequence where Trait == CompletableTrait {
    func toObservable() -> Observable<Void> {
        asObservable()
            .materialize()
            .take(1)
            .map { _ in }
    }
}
