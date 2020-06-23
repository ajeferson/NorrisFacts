//
//  TableViewSectionViewModelProtocol.swift
//  NorrisFacts
//
//  Created by Alan Paiva on 6/22/20.
//  Copyright © 2020 Alan Paiva. All rights reserved.
//

import Foundation

protocol TableViewSectionViewModelProtocol {
    var title: String { get }
    var numberOfItems: Int { get }

    func didSelectRow(at index: Int)
}

extension TableViewSectionViewModelProtocol {
    func didSelectRow(at index: Int) {}
}
