//
//  ProductListVC.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import Foundation

class ProductListVM {
    
    var category: Category?
    
    var data: Binder<[Card]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)
    
    var params = GetCard(pageNumber: 1,
                         cardTypes: [CardType.product.rawValue])
    
    var lastPage = false
    
    func getData(forPage: Int){
        if lastPage { return }
        if forPage == 1 && data.value.isEmpty {
            inProgress.value = true
        }
        
        params.categoryIds = [category?.id ?? ""]
        var params = params
        params.pageNumber = forPage
        ProductRequests.shared.getProducts(params: params) { [weak self] cards in
            guard let s = self else { return }
            
            s.inProgress.value = false
            
            guard let cards = cards else {
                s.noConnection.value = forPage == 1
                return
            }
            
            s.noConnection.value = false
            s.noContent.value = cards.isEmpty && forPage == 1
            s.lastPage = cards.isEmpty
            
            if forPage == 1 {
                s.data.value = cards
            } else {
                s.data.value.append(contentsOf: cards)
            }
            
            s.params.pageNumber = forPage
        }
    }
}
