//
//  AddShopVM.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import Foundation

class AddShopVM {
    
    var uploadImg: UploadImage?
    var shop: UserProfile?
    
    var inProgress: Binder<Bool> = Binder(false)
    var shopAdded: Binder<Bool> = Binder(false)
    var imgAdded: Binder<Bool> = Binder(false)

    func addShop(params: AddShop){
        inProgress.value = true
        
        UserRequests.shared.addShop(params: params) { [weak self] resp in
            self?.inProgress.value = false

            guard let resp = resp else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
                return
            }
                
            AccUserDefaults.shopIds.append(resp.id)
            self?.uploadImg?.objectId = resp.id
            self?.shopAdded.value = true
        }
    }
    
    func addImage(){
        inProgress.value = true
        Network.addImages(images: [uploadImg!]) { [weak self] resp in
            self?.inProgress.value = false
            if resp == true {
                self?.imgAdded.value = true
            } else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            }
        }
    }
}
