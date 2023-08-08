//
//  ProductListVC.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import UIKit

class ProductListVC: UIViewController {

    var viewModel = ProductListVM()
    
    var cellCount = 0
    
    var mainView: FeedView {
        return view as! FeedView
    }

    var pushVc: ( (_ vc: UIViewController)->() )?
    override func loadView() {
        super.loadView()
        view = FeedView()
        view.backgroundColor = .bg
        view.tag = 123456
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupView()
        setupCallbacks()
        setupBindings()
        viewModel.getData(forPage: 1)
    }
    
    func setupView(){
        mainView.collectionView.refreshControl = UIRefreshControl()
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        mainView.setupWithColView()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        let l = mainView.collectionView.collectionViewLayout as? PinterestLayout
        l?.delegate = self
        
        mainView.search.textField.text = viewModel.params.search
    }
    
    func setupBindings(){
        viewModel.data.bind { [weak self] data in
            self?.cellCount = data.count
            self?.mainView.collectionView.reloadData()
        }
        
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noContent.bind { [weak self] toShow in
            self?.mainView.noContent(toShow)
        }

        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
    }
    
    func setupCallbacks(){
        mainView.simpleHeader.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.filterBtn.clickCallback = { [weak self] in
            let vc = FilterCategoryListVC()
            vc.viewModel = CategoriesTabVM()
            vc.viewModel?.selectedCategories = self?.viewModel.params.categories ?? []
            vc.viewTag = self?.view.tag ?? 11
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.search.editingCallback = { [weak self] key in
            self?.viewModel.lastPage = false
            self?.viewModel.params.search = key
            self?.viewModel.getData(forPage: 1)
        }
        
        mainView.noConnection.btn.clickCallback = { [weak self] in
            self?.refresh()
        }
        
        mainView.noContent.btn.clickCallback = { [weak self] in
            self?.refresh()
        }
    }
    
    @objc func refresh(){
        mainView.collectionView.refreshControl?.endRefreshing()
        viewModel.lastPage = false
        viewModel.getData(forPage: 1)
    }
}

extension ProductListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.id, for: indexPath) as! FeedCell
        cell.setupData(data: viewModel.data.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductVC()
        vc.viewModel.id = viewModel.data.value[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
        pushVc?(vc)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item != cellCount - 1 { return }
        viewModel.getData(forPage: viewModel.params.pageNumber + 1)
    }
}

extension ProductListVC: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return withWidth * 1.4
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let text = viewModel.data.value[indexPath.row].name ?? ""
        return text.height(withConstrainedWidth: withWidth-100,
                           font: .lil_14) + 60
    }
}
