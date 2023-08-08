//
//  SubscribesPagerVC.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy
import Parchment

class SubscribesPagerVC: UIViewController {
    
    var id = ""
    var titles = ["user_subscribes".localized(), "shop_subscribes".localized()]
    var types = [SubscriberListType.userSubscribesOfUser, SubscriberListType.shopSubscribesOfUser]
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10)
    
    var header = Header(title: "subscribe_list")
    
    var pageControlBtn = CategoryBtnView()
    
    var pageVC: PagingViewController!
    
    var options = PagingOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        setupPageVc()

        view.addSubview(contentStack)
        view.backgroundColor = .bg
        contentStack.easy.layout(Edges())
        contentStack.addArrangedSubviews([header, pageControlBtn, pageVC.view])
        pageControlBtn.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }

    func setupPageVc(){
        options.menuItemSize = .sizeToFit(minWidth: 160, height: 30)
        pageVC = PagingViewController(options: options)
        pageVC.collectionView.isHidden = true
        pageVC.dataSource = self
        pageVC.delegate = self

        pageControlBtn.data = [Category(id: "",
                                        nameRu: "user_subscribes".localized(),
                                        nameTm: "user_subscribes".localized(),
                                        nameEn: "user_subscribes".localized()),
                               Category(id: "",
                                        nameRu: "shop_subscribes".localized(),
                                        nameTm: "shop_subscribes".localized(),
                                        nameEn: "shop_subscribes".localized())]
    }
}

extension SubscribesPagerVC: PagingViewControllerDataSource, PagingViewControllerDelegate {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return titles.count
    }
    
    func pagingViewController(_: Parchment.PagingViewController, pagingItemAt index: Int) -> Parchment.PagingItem {
        return PagingIndexItem(index: index, title: titles[index])
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = SubscriberListVC(id: id, type: types[index])
        vc.mainView.header.isHidden = true
        return vc
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        if transitionSuccessful {
            guard let ind = pagingViewController.visibleItems.indexPath(for: pagingItem) else { return }
            pageControlBtn.collectionView.selectItem(at: IndexPath(item: ind.item, section: 0), animated: true, scrollPosition: .left)
        }
    }
}
