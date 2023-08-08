//
//  ShopOrdersVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit
import Parchment

class ShopOrdersVC: UIViewController {
    
    var shopId = ""
    
    var pageVC: PagingViewController!

    var options = PagingOptions()
    
    var mainView: ShopOrdersView {
        return view as! ShopOrdersView
    }

    override func loadView() {
        super.loadView()
        view = ShopOrdersView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageVc()
        setupCallbacks()
        
        mainView.contentStack.addArrangedSubview(pageVC.view)
        mainView.optionsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    func setupPageVc(){
        options.menuItemSize = .sizeToFit(minWidth: 100, height: 0)
        pageVC = PagingViewController(options: options)
        pageVC.collectionView.isHidden = true
        pageVC.dataSource = self
        pageVC.delegate = self
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.optionsView.selectedAtInd = { [weak self] ind in
            self?.pageVC.select(index: ind, animated: true)
        }
    }
}

extension ShopOrdersVC: PagingViewControllerDataSource, PagingViewControllerDelegate {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 2
    }
    
    func pagingViewController(_: Parchment.PagingViewController, pagingItemAt index: Int) -> Parchment.PagingItem {
        return PagingIndexItem(index: index, title: "")
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = ShopOrdersListVC()
        vc.viewModel.params = GetOrders(statuses: [index+1], shopId: shopId)
        vc.pushVC = { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return vc
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        if transitionSuccessful {
            guard let ind = pagingViewController.visibleItems.indexPath(for: pagingItem) else { return }
            mainView.optionsView.collectionView.selectItem(at: IndexPath(item: ind.item, section: 0), animated: true, scrollPosition: .left)
        }
    }
}
