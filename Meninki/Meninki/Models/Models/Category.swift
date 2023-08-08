//
//  Category.swift
//  Meninki
//
//  Created by NyanDeveloper on 10.12.2022.
//

import Foundation

struct Category: Codable {
    var id: String
    var nameRu: String
    var nameTm: String
    var nameEn: String
    var categoryImage: String?
    var parentId: String?
    var subCategories: [Category]?
    
    func getTitle() -> String {
        switch AccUserDefaults.language {
        case "ru":
            return nameRu
            
        case "en":
            return nameEn
            
        default:
            return nameTm
        }
    }
}
