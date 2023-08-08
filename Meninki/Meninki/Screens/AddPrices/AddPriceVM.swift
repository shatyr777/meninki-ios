//
//  AddPriceVM.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import Foundation

class AddPriceVM {
    
    var productId = ""
    var personalChars: [PersonalCharacteristics] = []
    
    var inProgress: Binder<Bool> = Binder(false)
    var personalCharsAdded: Binder<Bool> = Binder(false)
    
    func updatePersonalChars(){
        if inProgress.value == true { return }
        inProgress.value = true

        AddRequests.shared.addPrices(prices: personalChars) { [weak self] resp in
            if resp == nil {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
                return
            }
            
            self?.personalCharsAdded.value = true
        }
    }
}
