//
//  ProductVM.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import Foundation

class ProductVM {
 
    var id: String = ""
    
    var product: Binder<Product?> = Binder(nil)
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)

    func getProduct(){
        inProgress.value = true
        ProductRequests.shared.getProduct(id: id) { [weak self] product in
            self?.inProgress.value = false
            self?.noConnection.value = product == nil
            self?.product.value = product
            if (product?.options ?? []).isEmpty == false {
//                product?.optionTitles?.count {
//
//                }
//                product?.options?.compactMap({})
            }
        }
    }
    
    func addToCart(){
        let params = AddToCart(productId: product.value?.id ?? "",
                               shopId: product.value?.shop?.id ?? "")
        
        
        ProductRequests.shared.addToCart(params: params) { [weak self] resp in
            guard let _ = self else { return }
            if resp == true {
                PopUpLauncher.showSuccessMessage(text: "added_to_cart".localized())
            } else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            }
        }
    }

    func changeRating(params: ChangeLike){
        MainRequests.shared.likePostProduct(params: params) { [weak self] rating in
            guard let rating = rating else  { return }
            self?.product.value?.rating = rating
        }
    }
}
