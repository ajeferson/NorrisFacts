//
//  SearchHistoryViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchHistoryViewModelInput {
    let loadQueries: Observable<Void>
}

struct SearchHistoryViewModelOutput {
    let queryTap: Driver<String>
}

protocol SearchHistoryViewModelProtocol: TableViewSectionViewModelProtocol {
    var output: SearchHistoryViewModelOutput { get }

    func item(for index: Int) -> String?
    func bind(input: SearchHistoryViewModelInput) -> Disposable
}

final class SearchHistoryViewModel: SearchHistoryViewModelProtocol {
    private let queryStore: QueryStoreProtocol
    private let queriesSubject = BehaviorRelay<[Query]>(value: [])
    private let queryTapSubject = PublishSubject<String>()

    var output: SearchHistoryViewModelOutput {
        .init(queryTap: queryTapSubject.asDriver(onErrorJustReturn: ""))
    }

    init(queryStore: QueryStoreProtocol) {
        self.queryStore = queryStore
    }

    var title: String {
        "Past Searches"
    }

    var numberOfItems: Int {
        queriesSubject.value.count
    }

    func didSelectRow(at index: Int) {
        guard let query = item(for: index) else {
            return
        }
        queryTapSubject.onNext(query)
    }

    func item(for index: Int) -> String? {
        let queries = queriesSubject.value
        guard index < queries.count else {
            return nil
        }
        return queries[index].name
    }

    func bind(input: SearchHistoryViewModelInput) -> Disposable {
        input
            .loadQueries
            .flatMap { [weak self] _ -> Single<[Query]> in
                guard let self = self else {
                    return .just([])
                }
                return self.queryStore.all(limit: 10)
            }
            .asDriver(onErrorJustReturn: [])
            .drive(queriesSubject)
    }
}
