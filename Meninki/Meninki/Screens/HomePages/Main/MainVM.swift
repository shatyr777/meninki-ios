//
//  MainVM.swift
//  Meninki
//
//  Created by Shirin on 4/24/23.
//

import Foundation

class MainVM {
    
    var data: Binder<[Home]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)

    var isRequesting = false
    var page = 1
    
    func getData(page: Int) {
        if isRequesting || page > 3 { return }
        
        guard let sPage = getStringValue(page: page) else { return }
        isRequesting = true
        inProgress.value = page == 1
        ProductRequests.shared.getHome(page: sPage) { [weak self] resp in
            self?.inProgress.value = false
            self?.noConnection.value = resp == nil && page == 1
            let configuredData = self?.setupData(resp: resp ?? []) ?? []
            if page == 1 {
                self?.data.value = configuredData
            } else {
                self?.data.value.append(contentsOf: configuredData)
            }
            self?.page = page
            self?.isRequesting = false
        }
    }
    
    func setupData(resp: [Home]?) -> [Home] {
        var data: [Home] = []
        resp?.forEach({ datum in
            var new = datum
            
            if datum.banner != nil {
                new.type = .banner
                new.banner = datum.banner
                data.append(new)
            } else if datum.popularPost != nil {
                new.type = .popularPosts
                new.popularPost = datum.popularPost
                data.append(new)
            } else if datum.popularProducts != nil {
                new.type = .popularProducts
                new.popularProducts = datum.popularProducts
                data.append(new)
            } else if datum.newProducts != nil {
                new.type = .newProducts
                new.newProducts = datum.newProducts
                data.append(new)
            } else if datum.shops != nil {
                new.type = .shops
                new.shops = datum.shops
                data.append(new)
            }
        })
        
        return data
    }

    func getStringValue(page: Int) -> String? {
        switch page {
        case 1:
            return "One"
            
        case 2:
            return "Two"
            
        case 3:
            return "Three"
            
        default:
            return nil
        }
    }
}
