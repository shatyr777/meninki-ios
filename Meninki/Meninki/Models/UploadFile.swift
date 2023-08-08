//
//  UploadFile.swift
//  BaseApp
//
//  Created by Shirin on 3/24/23.
//

import UIKit.UIImage

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
    var vertical: Bool
    var imgData: Data?
    var width: Int?
    var height: Int?
}
