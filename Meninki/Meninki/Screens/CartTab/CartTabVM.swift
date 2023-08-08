//
//  CartTabVM.swift
//  Meninki
//
//  Created by Shirin on 4/25/23.
//

import Foundation

class CartTabVM {
    
    var data: Binder<[Cart]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)

    func getInCart(){
        inProgress.value = true
        ProductRequests.shared.getInCart { [weak self] resp in
            self?.inProgress.value = false
            self?.noConnection.value = resp == nil
            self?.noContent.value = resp?.isEmpty == true
            self?.data.value = resp ?? []
        }
    }
    
    func changeInCartCount(params: AddToCart){
        ProductRequests.shared.addToCart(params: params) { [weak self] resp in
            guard let _ = self else { return }
            
            guard let shopInd = self?.data.value.firstIndex(where: {$0.shop.id == params.shopId}) else { return }
            guard let productInd = self?.data.value[shopInd].products.firstIndex(where: {$0.id == params.productId }) else { return }
            if resp == true {
                self?.data.value[shopInd].products[productInd].count = params.count
            }
        }
    }
}
