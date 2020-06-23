//
//  SearchHistoryViewModel.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

protocol SearchHistoryViewModelProtocol: TableViewSectionViewModelProtocol {
    func item(for index: Int) -> String?
}

final class SearchHistoryViewModel: SearchHistoryViewModelProtocol {
    var title: String {
        "Past Searches"
    }

    var numberOfItems: Int {
        5
    }

    func item(for index: Int) -> String? {
        return "Teste"
    }
}
