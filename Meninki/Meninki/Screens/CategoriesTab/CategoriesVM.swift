//
//  CategoriesVM.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import Foundation

class CategoriesTabVM {
    
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)
    var data: Binder<[Category]> = Binder([])
 
    var selectedCategories: [Category] = []
    
    func getCategories(){
        
        inProgress.value = true
        
        ProductRequests.shared.getCategories { [weak self] resp in
            self?.inProgress.value = false
            self?.noConnection.value = resp == nil
            self?.noContent.value = resp?.isEmpty == true
            self?.data.value = resp ?? []
        }
    }
}
