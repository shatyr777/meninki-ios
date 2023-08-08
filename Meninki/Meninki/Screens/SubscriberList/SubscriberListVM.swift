//
//  SubscriberListVM.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import Foundation


class SubscriberListVM {
    
    var type: SubscriberListType!
    var params = GetSubscribers(pageNumber: 1, id: "")
    
    var data: Binder<[User]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)

    var lastPage = false
    var isRequesting = false
    
    func getData(forPage: Int){
        if lastPage || isRequesting { return }
        isRequesting = true
        
        if forPage == 1 && data.value.isEmpty {
            inProgress.value = true
        }
        
        UserRequests.shared.getUserList(type: type, params: params){ [weak self] users in
            
            guard let s = self else { return }
            
            s.inProgress.value = false
            
            guard let users = users else {
                s.noConnection.value = forPage == 1
                return
            }
            
            s.noConnection.value = false
            s.noContent.value = users.isEmpty && forPage == 1
            s.lastPage = users.isEmpty
            
            if forPage == 1 {
                s.data.value = users
            } else {
                s.data.value.append(contentsOf: users)
            }
            
            s.params.pageNumber = forPage
            s.isRequesting = false
        }
    }
}
