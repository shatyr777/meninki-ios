//
//  Post.swift
//  Meninki
//
//  Created by Shirin on 4/22/23.
//

import Foundation

struct Post: Codable {
    var id: String
    var productId: String
    var productTitle: String
    var productMedia: String?
    var name: String
    var description: String
    var medias: [Media]
    var user: UserProfile?
    var rating: Rating?
}

struct Media: Codable {
    var id: String
    var path: String?
    var mediaType: MediaType.RawValue
    var preview: String?
}
