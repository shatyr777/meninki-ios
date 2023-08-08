//
//  Enums.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import Foundation


enum ImageType: Int {
    case user = 0
    case shop = 1
    case category = 2
    case banner = 3
    case advertisementBoard = 4
    case media = 5
    case option = 6
}

enum SortType: Int {
    static let allValues: [SortType.RawValue] = [0,1,2,3]
    static let allTitles: [String] = ["date".localized(),
                                      "viewed_number".localized(),
                                      "rating".localized(),
                                      "price".localized()]

    case date = 0
    case viewedNumber = 1
    case rating = 2
    case price = 3
}

enum CardType: Int, CaseIterable {
    static let allValues: [CardType.RawValue] = [1,3]
    static let allTitles: [String] = ["all".localized(),
                                      "product".localized(),
                                      "posts".localized()]

    case product = 1
    case post = 3
}

enum MediaType: Int {
    case image = 0
    case video = 1
}

enum OptionType: Int {
    case text = 1
    case image = 2
}

enum OrderStatus: Int {
    case inCart = 0
    case ordered = 1
    case delivered = 2
}
