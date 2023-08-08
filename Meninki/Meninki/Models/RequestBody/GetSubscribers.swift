//
//  GetSubscribers.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import Foundation

struct GetSubscribers: Codable {
    var take: Int = 20
    var pageNumber: Int
    var id: String
    var subscriber: Bool?
}
