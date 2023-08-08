//
//  Category.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import Foundation

struct Category: Codable {
    var id: String
    var nameRu: String
    var nameTm: String
    var nameEn: String
    var categoryImage: String?
    var parentId: String?
    var advertisement: CategoryAd?
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

struct CategoryAd: Codable {
    var name: String
    var url: String
}
