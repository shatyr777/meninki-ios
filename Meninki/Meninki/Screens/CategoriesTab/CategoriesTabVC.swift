//
//  CategoriesTabVC.swift
//  Meninki
//
//  Created by Shirin on 3/30/23.
//

import UIKit
import Parchment

class CategoriesTabVC: UIViewController {

    let viewModel = CategoriesTabVM()
    
    var pageVC: PagingViewController!

    var options = PagingOptions()

    var current = -1
    
    var mainView: CategoriesTabView {
        return view as! CategoriesTabView
    }

    override func loadView() {
        super.loadView()
        view = CategoriesTabView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageVc()
        mainView.addViewToContainer(pageVC.view)
        
        setupBindings()
        setupCallbacks()
        viewModel.getCategories()
    }
    
    func setupPageVc(){
        options.menuItemSize = .sizeToFit(minWidth: 100, height: 30)
        pageVC = PagingViewController(options: options)
        pageVC.collectionView.isHidden = true
        pageVC.dataSource = self
        pageVC.delegate = self
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noContent.bind { [weak self] toShow in
            self?.mainView.noContent(toShow)
        }

        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
        
        viewModel.data.bind { [weak self] categories in
            self?.mainView.btns.data = categories
            self?.pageVC.reloadData()
            if (self?.current ?? -1) < 0 {
                if categories.isEmpty { return }
                self?.current = 0
                self?.mainView.btns.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
            }
        }
    }
    
    func setupCallbacks(){
        mainView.search.beginEditingCallback = { [weak self] in
            let vc = SearchVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.filterBtn.clickCallback = { [weak self] in
            self?.navigationController?.pushViewController(FilterVC(), animated: true)
        }
        mainView.btns.selectedAtInd = { [weak self] ind in
            self?.pageVC.select(index: ind, animated: true)
        }
    }
}

extension CategoriesTabVC: PagingViewControllerDataSource, PagingViewControllerDelegate {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return viewModel.data.value.count
    }
    
    func pagingViewController(_: Parchment.PagingViewController, pagingItemAt index: Int) -> Parchment.PagingItem {
        return PagingIndexItem(index: index, title: "")
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = CategoryListVC(categories: viewModel.data.value[index].subCategories ?? [])
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
