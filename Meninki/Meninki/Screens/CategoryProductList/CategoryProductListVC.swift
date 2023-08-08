//
//  CategoryProductListVC.swift
//  Meninki
//
//  Created by Shirin on 4/3/23.
//

import UIKit
import Parchment

class CategoryProductListVC: UIViewController {

    var viewModel = CategoryProductListVM()

    var pageVC: PagingViewController!

    var options = PagingOptions()

    var isEmpty = false
    
    var mainView: CategoryProductListView {
        return view as! CategoryProductListView
    }

    override func loadView() {
        super.loadView()
        view = CategoryProductListView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (viewModel.category?.subCategories ?? []).isEmpty == true {
            mainView.btns.removeFromSuperview()
            isEmpty = true
        } else {
            mainView.btns.data = viewModel.category?.subCategories ?? []
            mainView.btns.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
        }
        
        setupPageVc()
        setupCallbacks()
    }
    
    func setupPageVc(){
        options.menuItemSize = .fixed(width: .zero, height: .zero)
        pageVC = PagingViewController(options: options)
        pageVC.collectionView.isHidden = true
        pageVC.dataSource = self
        pageVC.delegate = self
        mainView.addViewToContainer(pageVC.view)
    }    

    func setupCallbacks(){
        mainView.btns.selectedAtInd = { [weak self] ind in
            self?.pageVC.select(index: ind, animated: true)
        }
        
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension CategoryProductListVC: PagingViewControllerDataSource, PagingViewControllerDelegate {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return !isEmpty ? viewModel.category?.subCategories?.count ?? 0 : 1
    }
    
    func pagingViewController(_: Parchment.PagingViewController, pagingItemAt index: Int) -> Parchment.PagingItem {
        return PagingIndexItem(index: index, title: "")
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = ProductListVC()
        vc.viewModel.category = !isEmpty ? viewModel.category?.subCategories?[index] : viewModel.category
        vc.pushVc = { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return vc
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        if transitionSuccessful {
            guard let ind = pagingViewController.visibleItems.indexPath(for: pagingItem) else { return }
            mainView.btns.collectionView.selectItem(at: IndexPath(item: ind.item, section: 0), animated: true, scrollPosition: .left)
        }
    }
}
