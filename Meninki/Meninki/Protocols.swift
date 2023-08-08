//
//  Protocols.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit

protocol TabBarDelegate: AnyObject {
    func didScroll(toShow: Bool)
}

protocol FeedBSDelegate: AnyObject {
    func like(id: String?)
    func dislike(id: String?)
    func copyPath(path: String?)
    func goToProduct(productId: String?)
    func goToUserProfile(userId: String?)
    func goToShopProfile(shopId: String?)
    func complain(id: String?)
}

protocol MainClicksDelegate: AnyObject {
    func openProduct(data: Card?)
    func openPost(feedVM: FeedVM?, ind: Int)
    func openBS(vc: UIViewController?)
    func openVC(vc: UIViewController?)
}

protocol UserProfileClicks: AnyObject {
    func openSubscribers()
    func openSubscribes()
    func openShopProfile(id: String?)
    func openEditProfile()
    func openSettings()
    func openAddShop()
    func subscribe()
    func unsubscribe()
}

protocol ShopProfileClicks: AnyObject {
    func openSubscribers()
    func openSettings()
    func openContacts()
    func openOrders()
    func subscribe()
    func unsubscribe()
}
