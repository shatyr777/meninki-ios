//
//  FilterCategoryListVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit

enum FilterCategoryListType {
    case category
    case subcategory
}

class FilterCategoryListVC: UIViewController {
    
    var type = FilterCategoryListType.category

    var viewModel: CategoriesTabVM?
    
    var dataToShow: [Category] = []
    
    var mainView: FilterCategoryListView {
        return view as! FilterCategoryListView
    }

    var viewTag = 0
    
    override func loadView() {
        super.loadView()
        view = FilterCategoryListView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setupCallbacks()
        
        if type == .category {
            viewModel?.getCategories()
            setupBindings()
        }
    }
    
    func setupBindings(){
        viewModel?.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel?.noContent.bind { [weak self] toShow in
            self?.mainView.noContent(toShow)
        }

        viewModel?.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
        
        viewModel?.data.bind { [weak self] categories in
            if categories.isEmpty { return }
            self?.dataToShow = categories
            self?.mainView.tableView.reloadData()
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.header.trailingBtn.clickCallback = { [weak self] in
            let vc = self?.sendDataBack()
            self?.navigationController?.popToViewController(vc!, animated: true)

        }
    }
    
    func sendDataBack() -> UIViewController {
        guard let vc = navigationController?.viewControllers.first(where: {$0.view.tag == viewTag}) else { return UIViewController() }
        if let addShopVC = vc as? AddShopVC {
            addShopVC.selectedCats = viewModel?.selectedCategories ?? []
            return addShopVC
        }
        
        if let addProductVC = vc as? AddProductVC {
            addProductVC.selectedCats = viewModel?.selectedCategories ?? []
            return addProductVC
        }
        
        if let filterVC = vc as? FilterVC {
            filterVC.params.categories = viewModel?.selectedCategories ?? []
            return filterVC
        }
        
        if let productListVC = vc as? ProductListVC {
            productListVC.viewModel.params.categories = viewModel?.selectedCategories ?? []
            return productListVC
        }
        
        return vc
    }
}

extension FilterCategoryListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterCategoryTbCell.id, for: indexPath) as! FilterCategoryTbCell
        let cat = dataToShow[indexPath.row]
        cell.setupData(data: cat)
        cell.checkbox.checked = viewModel?.selectedCategories.contains(where: {$0.id == cat.id}) == true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = dataToShow[indexPath.row]
        let subs = cat.subCategories ?? []
        if subs.isEmpty {
            guard let cell = tableView.cellForRow(at: indexPath) as? FilterCategoryTbCell else { return }
            if cell.checkbox.checked {
                viewModel?.selectedCategories.removeAll(where: {$0.id == cat.id})
                cell.checkbox.checked = false
            } else {
                viewModel?.selectedCategories.append(cat)
                cell.checkbox.checked = true
            }
            
        } else {
            print(subs)
            let vc = FilterCategoryListVC()
            vc.dataToShow = subs
            vc.type = .subcategory
            vc.viewModel = viewModel
            vc.viewTag = viewTag
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
