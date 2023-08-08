//
//  GetCard.swift
//  Meninki
//
//  Created by NyanDeveloper on 29.01.2023.
//

import Foundation

struct GetCard: Codable {
    var take: Int = 10
    var pageNumber: Int
    var minPrice: Float?
    var maxPrice: Float?
    var categoryIds: [String]? = nil
    var cardTypes: [Int] = [0,1,2,3]
    var sortType: SortType.RawValue = 0
    var descending: Bool = true
    var search: String?
    var userId: String?
    var shopId: String?
}

struct GetShop: Codable {
    var sortType: SortType.RawValue = 0
    var descending: Bool = true
    var categoryIds: [String]?
    var pageNumber = 1
    var take = 4
}

struct GetSubscriber: Codable {
    var subscriber: Bool?
    var status: Int?
    var userId: String?
    var id: String?
    var pageNumber: Int? = nil
    var take: Int = 20
}

struct GetInCart: Codable {
    var shopId: String?
    var orderStatus: Int?
}

struct GetOrders: Codable {
    var statuses: [OrderStatus.RawValue]
    var shopId: String
}

