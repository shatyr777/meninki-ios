//
//  AddProductVM.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import Foundation

class AddProductVM {

    var shop: UserProfile?
    var productId = UUID().uuidString
    
    var inProgress: Binder<Bool> = Binder(false)
    var productAdded: Binder<Bool> = Binder(false)
    var imgAdded: Binder<Bool> = Binder(false)

    func addProduct(toAdd: Bool, params: AddProduct){
        if inProgress.value == true { return }
        inProgress.value = true
        
        AddRequests.shared.addProduct(toAdd: toAdd, params: params) { [weak self] resp in
            self?.inProgress.value = false

            if resp == nil {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
                return
            }
            
            self?.productAdded.value = true
        }
    }
    
    func addImage(images: [UploadImage]){
        if inProgress.value == true { return }
        inProgress.value = true
        
        Network.addImages(images: images) { [weak self] resp in
            self?.inProgress.value = false
            
            if resp == true {
                self?.imgAdded.value = true
            } else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            }
        }
    }
}
