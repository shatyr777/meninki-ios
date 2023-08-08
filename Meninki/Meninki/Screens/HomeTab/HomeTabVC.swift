//
//  HomeTabVC.swift
//  Meninki
//
//  Created by Shirin on 3/30/23.
//

import UIKit
import Parchment
import EasyPeasy

class HomeTabVC: UIViewController {
    
    lazy var vc = [FeedVC.self, FeedVC.self]
    lazy var titles = ["feed".localized(), "home".localized()]
   
    var pageVC: PagingViewController!

    var options = PagingOptions()

    var mainView: HomeTabView {
        return view as! HomeTabView
    }

    override func loadView() {
        super.loadView()
        view = HomeTabView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageVc()
        mainView.addPagerView(pageVC.view)
    }
    
    
    func setupPageVc(){
        options.menuItemSize = .sizeToFit(minWidth: 100, height: 48)
        options.menuBackgroundColor = .onBgLc
        options.borderColor = .clear
        
        options.indicatorClass = RoundedIndicatorView.self
        options.indicatorColor = .contrast
        options.indicatorOptions = .visible(height: 40,
                                            zIndex: -1,
                                            spacing: UIEdgeInsets(edges: 4),
                                            insets:  UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4))

        options.font = .lil_14_b
        options.selectedFont = .lil_14_b
        options.textColor = .neutralDark
        options.selectedTextColor = .white
        
        pageVC = PagingViewController(options: options)
        pageVC.collectionView.layer.cornerRadius = 24
        pageVC.dataSource = self
    }
}

extension HomeTabVC: PagingViewControllerDataSource {
    func numberOfViewControllers(in _: PagingViewController) -> Int {
        return vc.count
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: titles[index])
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        switch index {
        case 0:
            let vc = FeedVC()
            vc.pushVc = { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return vc

        default:
            let vc = MainVC()
            vc.pushVc = { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return vc
        }
    }
}
