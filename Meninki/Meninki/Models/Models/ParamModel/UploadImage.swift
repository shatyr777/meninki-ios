//
//  UploadImage.swift
//  Meninki
//
//  Created by NyanDeveloper on 17.01.2023.
//

import UIKit

struct UploadImage {
    var objectId: String
    var isAvatar: Bool
    var imageType: ImageType.RawValue
    var width: Int?
    var height: Int?
    var filename: String?
    var data: Data?
}

struct UploadVideo {
    var objectId: String
    var filename: String = "exported.mov"
    var image: UIImage?
    var path: URL?
    var data: Data?
}
