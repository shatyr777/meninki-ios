//
//  Banner.swift
//  Meninki
//
//  Created by Shirin on 4/25/23.
//

import Foundation

struct Banner: Codable {
    var id: String
    var title: String?
    var description: String?
    var url: String?
    var bannerImage: BannerImage?
}

struct BannerImage: Codable {
    var id: String
    var orientationType: Int
    var imageType: Int
    var directoryCompressed: String?
    var directoryThumbnails: String?
    var directoryOriginal: String?
}
