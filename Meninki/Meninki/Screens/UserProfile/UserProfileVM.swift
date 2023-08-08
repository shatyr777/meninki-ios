//
//  UserProfileVM.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import Foundation

class UserProfileVM {
    
    var id: String! {
        didSet {
            isOwn = id == AccUserDefaults.id
            postVM = FeedVM()
            postVM?.params.userId = id
        }
    }
        
    var isOwn = false
    var user: Binder<UserProfile?> = Binder(nil)
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    
    var postVM: FeedVM?

    func getUser(){
        inProgress.value = true

        UserRequests.shared.getUserProfile(id: id, completionHandler: { [weak self] profile in
            self?.inProgress.value = false

            if profile == nil {
                self?.noConnection.value = true
                return
            }

            self?.user.value = profile
            self?.postVM?.getData(forPage: 1)
        })
    }

    func changeSubscriptionStatus(params: ChangeLike){
        UserRequests.shared.changeUserSubscribeStatus(params: params) { [weak self] resp in
            if resp == nil {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            } else {
                self?.user.value?.isSubscribed = params.isSubscribe ?? false
            }
        }
    }
}
