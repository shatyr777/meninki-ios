//
//  ConfirmOrderVM.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import Foundation

class ConfirmOrderVM {
    
    var inProgress: Binder<Bool> = Binder(false)
    var success: Binder<Bool?> = Binder(false)
    
    func order(params: OrderProduct){
        if inProgress.value == true { return }
       
        inProgress.value = true
        
        ProductRequests.shared.orderProducts(params: params) { [weak self] resp in
            self?.inProgress.value = false
            if resp == nil {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            } else {
                self?.success.value = true
            }
        }
    }

}
