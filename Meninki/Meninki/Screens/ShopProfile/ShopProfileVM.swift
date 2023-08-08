//
//  ShopProfileVM.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import Foundation


class ShopProfileVM {
    
    var shop: Binder<UserProfile?> = Binder(nil)
    var data: Binder<[Card]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)

    
    var lastPage = false
    var isRequesting = false
    var params = GetCard(pageNumber: 1,
                         cardTypes: [CardType.product.rawValue])

    var id: String! {
        didSet {
            params.shopId = id
        }
    }
    
    func getShop(){
        inProgress.value = true

        UserRequests.shared.getShopProfile(id: id, completionHandler: { [weak self] profile in
            if profile == nil {
                self?.noConnection.value = true
                return
            }
            
            self?.shop.value = profile
            self?.lastPage = false
            self?.getData(forPage: 1)
        })
    }
    
    
    func getData(forPage: Int){
        if lastPage || isRequesting { return }
        if forPage == 1 && data.value.isEmpty {
            inProgress.value = true
        }
        isRequesting = true
        params.shopId = id
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

    
    func changeSubscriptionStatus(params: ChangeLike){
        UserRequests.shared.changeShopSubscribeStatus(params: params) { [weak self] resp in
            if resp == nil {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            } else {
                self?.shop.value?.isSubscribed = params.isSubscribe ?? false
            }
        }
    }
}
