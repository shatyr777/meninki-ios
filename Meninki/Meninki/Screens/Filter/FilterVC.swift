//
//  FilterVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 19.05.2023.
//

import UIKit

class FilterVC: UIViewController {

    var params = GetCard(pageNumber: 1)
    
    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var mainView: FilterView {
        return view as! FilterView
    }

    var pushVc: ( (_ vc: UIViewController)->() )?
    override func loadView() {
        super.loadView()
        view = FilterView()
        view.backgroundColor = .bg
        view.tag = 123
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCallbacks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.category.setTextViewText(params.categories?.map({ $0.getTitle()}).joined(separator: ", ") ?? "all".localized())
    }

    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.sort.clickCallback = { [weak self] in
            self?.openSortBS()
        }
        
        mainView.category.clickCallback = { [weak self] in
            let vc = FilterCategoryListVC()
            vc.viewModel = CategoriesTabVM()
            vc.viewModel?.selectedCategories = self?.params.categories ?? []
            vc.viewTag = self?.view.tag ?? 11
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            let vc = ProductListVC()
            vc.viewModel.params = self?.params ?? GetCard(pageNumber: 1)
            vc.mainView.setupWithSearch()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openSortBS(){
        let vc = SortBS()
        vc.selectionCallback = { [weak self] sortType in
            self?.mainView.sort.textField.text = SortType.allTitles[sortType]
            self?.params.sortType = sortType
        }

        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        present(vc, animated: true)
    }
}
