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

private enum DisplayMode {
    case all
    case categoryList
    case searchHistory
    case none
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
    var numberOfSections: Int { get }
    var output: FactSearchViewModelOutput { get }

    var categoryListViewModel: CategoryListViewModelProtocol { get }
    var searchHistoryViewModel: SearchHistoryViewModelProtocol { get }

    func bind(input: FactSearchViewModelInput) -> Disposable
    func bind(categoryTap: Observable<String>) -> Disposable
    func bind(queryTap: Observable<String>) -> Disposable

    func sectionViewModel(at index: Int) -> TableViewSectionViewModelProtocol?
}

final class FactSearchViewModel {
    private enum Constants {
        static let searchDebounceTime = DispatchTimeInterval.milliseconds(250)
    }

    weak var coordinator: FactSearchCoordinatorProtocol?

    private let factProvider: FactProviderProtocol
    private let categoryStore: CategoryStoreProtocol
    private let queryStore: QueryStoreProtocol
    private let scheduler: SchedulerType

    private let isLoadingSubject = BehaviorRelay(value: false)
    private let categoriesSubject = BehaviorSubject(value: [String]())
    private let errorSubject = PublishSubject<ErrorDescriptor>()
    private let categoryTapSubject = PublishSubject<String>()
    private let queryTapSubject = PublishSubject<String>()

    let categoryListViewModel: CategoryListViewModelProtocol
    let searchHistoryViewModel: SearchHistoryViewModelProtocol

    private var displayMode: DisplayMode = .none

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

    func bindDisplayMode() -> Disposable {
        Observable.combineLatest(
            categoryStore.all().map { !$0.isEmpty }.asObservable(),
            queryStore.all(limit: 1).map { !$0.isEmpty }.asObservable()
        )
        .map { (hasCategories, hasPastSearches) -> DisplayMode in
            switch (hasCategories, hasPastSearches) {
            case (false, false):
                return .none
            case (false, true):
                return .searchHistory
            case (true, true):
                return .all
            case (true, false):
                return .categoryList
            }
        }
        .subscribe(onNext: { [weak self] displayMode in
            self?.displayMode = displayMode
        })
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

        let persistableQuery = Observable.merge(textQuery, queryTapSubject)

        let query = Observable
            .merge(persistableQuery, categoryTapSubject)
            .share()

        let searchResult = makeObservableSearhResult(from: query)

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
                .bind(to: errorSubject)
        )
    }

    //swiftlint:disable:next function_body_length
    private func makeObservableSearhResult(from query: Observable<String>) -> Observable<Result<[Fact], Error>> {
        let networkResult = query
            .flatMapLatest { [weak self] query -> Observable<Result<[Fact], Error>> in
                guard let self = self else {
                    return .empty()
                }
                return self.factProvider
                    .search(query: query, scheduler: self.scheduler)
                    .asObservable()
                    .mapToResult()
            }
            .share()

        let networkCacheResult = networkResult
            .withLatestFrom(query) { ($1, $0) }
            .flatMap { [weak self] query, result -> Observable<Result<Void, Error>> in
                guard let self = self else {
                    return .empty()
                }
                switch result {
                case .failure(let error):
                    return .just(.failure(error))
                case .success(let facts):
                    let queryObject = Query(name: query)
                    return self.queryStore
                        .save(query: queryObject, with: facts).toObservable()
                        .mapToResult()
                }
            }
            .share()

        return networkCacheResult
            .withLatestFrom(query) { ($1, $0) }
            .flatMap { [weak self] queryName, result -> Observable<(Query?, Error?)> in
                guard let self = self else {
                    return .empty()
                }
                return self.queryStore
                    .getBy(name: queryName)
                    .asObservable()
                    .map { ($0, result.getError()) }
            }
            .map { query, networkError -> Result<[Fact], Error> in
                switch (query, networkError) {
                case let (.some(unwrappedQuery), _):
                    return .success(Array(unwrappedQuery.facts))
                case let (_, .some(error)):
                    return .failure(error)
                default:
                    return .success([])
                }
            }
            .share()
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
    var numberOfSections: Int {
        switch displayMode {
        case .none:
            return 0
        case .categoryList, .searchHistory:
            return 1
        case .all:
            return 2
        }
    }

    func sectionViewModel(at index: Int) -> TableViewSectionViewModelProtocol? {
        switch (displayMode, index) {
        case (.categoryList, 0), (.all, 0):
            return categoryListViewModel
        case (.searchHistory, 0), (.all, 1):
            return searchHistoryViewModel
        default:
            return nil
        }
    }

    func bind(input: FactSearchViewModelInput) -> Disposable {
        Disposables.create(
            bindDisplayMode(),
            bindCancel(input),
            bindSearch(input)
        )
    }

    func bind(categoryTap: Observable<String>) -> Disposable {
        categoryTap.bind(to: categoryTapSubject)
    }

    func bind(queryTap: Observable<String>) -> Disposable {
        queryTap.bind(to: queryTapSubject)
    }
}
