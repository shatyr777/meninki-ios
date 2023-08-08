//
//  GetCard.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import Foundation

struct GetCard: Codable {
    var take: Int = 10
    var pageNumber: Int
    var minPrice: Float?
    var maxPrice: Float?
    var categoryIds: [String]? = nil
    var cardTypes: [Int]? = [1,3]
    var sortType: SortType.RawValue = 0
    var descending: Bool = true
    var search: String?
    var userId: String?
    var shopId: String?
    var categories: [Category]?
}
