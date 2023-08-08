//
//  CategoryProductListVM.swift
//  Meninki
//
//  Created by Shirin on 4/3/23.
//

import Foundation

class CategoryProductListVM {
    
    var category: Category?
    
    
    var data: Binder<[Card]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)
    
    var params = GetCard(pageNumber: 1, cardTypes: [CardType.product.rawValue])
    var lastPage = false
    var isRequesting = false
    
    func getData(forPage: Int){
        if lastPage || isRequesting { return}
        isRequesting = true
        if forPage == 1 && data.value.isEmpty {
            inProgress.value = true
        }
        
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
            s.isRequesting = false
        }
    }
    
    func changeRating(params: ChangeLike){
        MainRequests.shared.likePostProduct(params: params) { [weak self] rating in
            guard let s = self else { return }
            guard let rating = rating else  { return }
            guard let ind = s.data.value.firstIndex(where: {$0.id == params.id }) else { return }
            var post = s.data.value[ind]
            post.rating = rating
            s.data.value[ind] = post
        }
    }
    
}
