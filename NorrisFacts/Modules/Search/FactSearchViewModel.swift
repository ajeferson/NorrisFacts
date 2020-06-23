//
//  FactSearchViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/20/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum SearchResult {
    case cancel
    case success([Fact])
}

struct FactSearchViewModelInput {
    let cancelButtonClicked: Observable<Void>
    let searchButtonClicked: Observable<Void>
    let searchText: Observable<String?>
}

struct FactSearchViewModelOutput {
    let isLoading: Driver<Bool>
    let error: Driver<ErrorDescriptor>
}

protocol FactSearchViewModelProtocol {
    var output: FactSearchViewModelOutput { get }

    var categoryListViewModel: CategoryListViewModelProtocol { get }
    var searchHistoryViewModel: SearchHistoryViewModelProtocol { get }

    func bind(input: FactSearchViewModelInput) -> Disposable
    func bind(categoryTap: Observable<String>) -> Disposable
}

final class FactSearchViewModel {
    weak var coordinator: FactSearchCoordinatorProtocol?
    private let factProvider: FactProviderProtocol
    private let categoryStore: CategoryStoreProtocol
    private let queryStore: QueryStoreProtocol
    private let scheduler: SchedulerType

    private let isLoadingSubject = BehaviorRelay(value: false)
    private let categoriesSubject = BehaviorSubject(value: [String]())
    private let errorSubject = PublishSubject<ErrorDescriptor>()
    private let querySubject = PublishSubject<String>()

    let categoryListViewModel: CategoryListViewModelProtocol
    let searchHistoryViewModel: SearchHistoryViewModelProtocol

    private enum Constants {
        static let searchDebounceTime = DispatchTimeInterval.milliseconds(250)
    }

    var output: FactSearchViewModelOutput {
        .init(
            isLoading: isLoadingSubject.asDriver(),
            error: errorSubject.asDriver(onErrorJustReturn: .general)
        )
    }

    init(coordinator: FactSearchCoordinatorProtocol,
         factProvider: FactProviderProtocol,
         categoryStore: CategoryStoreProtocol,
         queryStore: QueryStoreProtocol,
         scheduler: SchedulerType) {
        self.coordinator = coordinator
        self.factProvider = factProvider
        self.categoryStore = categoryStore
        self.queryStore = queryStore
        self.scheduler = scheduler

        categoryListViewModel = CategoryListViewModel(categoryStore: categoryStore)
        searchHistoryViewModel = SearchHistoryViewModel(queryStore: queryStore)
    }

    private func bindCancel(_ input: FactSearchViewModelInput) -> Disposable {
        input
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.finish(searchResult: .cancel)
            })
    }

    private func bindSearch(_ input: FactSearchViewModelInput) -> Disposable {
        let textQuery = input
            .searchButtonClicked
            .withLatestFrom(input.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .debounce(Constants.searchDebounceTime, scheduler: scheduler)

        let query = Observable
            .merge(textQuery, querySubject)
            .share()

        let searchResult = query
            .flatMapLatest { [weak self] query -> Observable<Result<[Fact], Error>> in
                guard let self = self else {
                    return .empty()
                }
                return self.factProvider
                    .search(query: query)
                    .asObservable()
                    .mapToResult()
            }
            .share()

        return Disposables.create(
            // Loading state
            Observable.merge(
                query.map { _ in true },
                searchResult.compactMap { $0.getError() }.map { _ in false }
            )
            .bind(to: isLoadingSubject),

            // Search results
            searchResult
                .compactMap { try? $0.get() }
                .subscribe(onNext: { [weak self] facts in
                    self?.coordinator?.finish(searchResult: .success(facts))
                }),

            // Search error
            searchResult
                .compactMap { $0.getError() }
                .map(map(error:))
                .bind(to: errorSubject),

            searchResult
                .withLatestFrom(textQuery)
                .flatMap { [weak self] query -> Completable in
                    guard let self = self else {
                        return .empty()
                    }

                    let queryObject = Query(name: query)
                    return self.queryStore.save(query: queryObject)
                }
                .subscribe()
        )
    }

    private func map(error: Error) -> ErrorDescriptor {
        guard let apiError = error as? APIError else {
            return .general
        }

        switch apiError {
        case .serverError:
            return .server
        case .network:
            return .network
        case .underlying, .unknown, .badRequest, .redirect:
            return .general
        }
    }
}

extension FactSearchViewModel: FactSearchViewModelProtocol {
    func bind(input: FactSearchViewModelInput) -> Disposable {
        Disposables.create(
            bindCancel(input),
            bindSearch(input)
        )
    }

    func bind(categoryTap: Observable<String>) -> Disposable {
        categoryTap.bind(to: querySubject)
    }
}
