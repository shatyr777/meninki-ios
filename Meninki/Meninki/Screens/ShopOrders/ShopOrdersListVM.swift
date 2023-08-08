//
//  ShopOrdersListVM.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import Foundation

class ShopOrdersListVM {
    
    var params = GetOrders(statuses: [], shopId: "")
    
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)
    var data: Binder<[ShopOrder]> = Binder([])
 
    func getData(){
        inProgress.value = true
        
        ProductRequests.shared.getShopOrders(params: params) { [weak self] resp in
            self?.inProgress.value = false
            self?.noConnection.value = resp == nil
            self?.noContent.value = resp?.isEmpty == true
            self?.data.value = resp ?? []
        }
    }
    
    func changeStatus(params: ChangeOrder){
        ProductRequests.shared.changeOrderStatus(params: params) { [weak self] resp in
            guard let ind = self?.data.value.firstIndex(where: {$0.id == params.id }) else { return }

            if resp == true {
                self?.data.value[ind].orderStatus = params.orderStatus
            }
        }
    }
}
