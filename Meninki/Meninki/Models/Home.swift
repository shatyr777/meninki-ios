//
//  Home.swift
//  Meninki
//
//  Created by Shirin on 4/24/23.
//

import Foundation

enum HomeDataType: Codable {
    case popularPosts
    case popularProducts
    case newProducts
    case newPosts
    case shops
    case banner
}

struct Home: Codable {
    var type: HomeDataType?
    var banner: Banner?
    var popularProducts: [Card]?
    var popularPost: [Post]?
    var newProducts: [Card]?
    var newPosts: [Post]?
    var shops: [Cart]?
}
