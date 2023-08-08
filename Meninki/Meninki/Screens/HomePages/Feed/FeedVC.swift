//
//  FeedVC.swift
//  Meninki
//
//  Created by Shirin on 3/30/23.
//

import UIKit

class FeedVC: UIViewController {

    var viewModel = FeedVM()
    
    var lastOffset: CGFloat = 0
    
    var cellCount = 0
    
    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var mainView: FeedView {
        return view as! FeedView
    }

    var pushVc: ( (_ vc: UIViewController)->() )?
    
    override func loadView() {
        super.loadView()
        view = FeedView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        setupCallbacks()
        
        viewModel.getData(forPage: 1)
    }
    
    func setupView(){
        mainView.collectionView.refreshControl = UIRefreshControl()
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        let l = mainView.collectionView.collectionViewLayout as? PinterestLayout
        l?.delegate = self
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
        mainView.header.sortBtn.clickCallback = { [weak self] in
            self?.openSortBS()
        }
        
        mainView.noContent.btn.clickCallback = { [weak self] in
            self?.refresh()
        }
        
        mainView.noConnection.btn.clickCallback = { [weak self] in
            self?.refresh()
        }
    }
    
    func openSortBS(){
        let vc = SortBS()
        vc.selectionCallback = { [weak self] sortType in
            self?.mainView.header.setupDesc(sortType: sortType)
            self?.viewModel.params.sortType = sortType
            self?.viewModel.getData(forPage: 1)
        }

        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        present(vc, animated: true)
    }
    
    func openMoreBS(post: Post?){
        let vc = FeedMoreBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.delegate = self
        vc.data = post
        present(vc, animated: true)
    }
    
    @objc func refresh(){
        mainView.collectionView.refreshControl?.endRefreshing()
        viewModel.lastPage = false
        viewModel.getData(forPage: 1)
    }
}

extension FeedVC: FeedBSDelegate {
    func like(id: String?) {
        guard let id = id else { return }
        let params = ChangeLike(id: id, isIncrease: true)
        viewModel.changeRating(params: params)
    }
    
    func dislike(id: String?) {
        guard let id = id else { return }
        let params = ChangeLike(id: id, isIncrease: nil)
        viewModel.changeRating(params: params)
    }
    
    func copyPath(path: String?) {
        if (path ?? "").isEmpty == true {
            showToast(message: "copy_failed".localized())
        } else {
            UIPasteboard.general.string = path ?? ""
            showToast(message: "copied".localized())
        }
    }
    
    func goToProduct(productId: String?) {
        let vc = ProductVC()
        vc.viewModel.id = productId ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToUserProfile(userId: String?) {
        let vc = UserProfileVC()
        vc.viewModel.id = userId ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToShopProfile(shopId: String?) {
        let vc = ShopProfileVC()
        vc.viewModel.id = shopId ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }

    func complain(id: String?) {
        print("OPEN COMPLAIN")
    }
}

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.id, for: indexPath) as! FeedCell
        let post = viewModel.data.value[indexPath.row]
        cell.setupData(data: post)
        cell.moreBtn.clickCallback = { [weak self] in
            self?.openMoreBS(post: post)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PostPagerVC(viewModel: viewModel, current: indexPath.item)
        pushVc?(vc)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item < cellCount - 1 { return }
        print(viewModel.params.pageNumber)
        viewModel.getData(forPage: viewModel.params.pageNumber + 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let current = scrollView.contentOffset.y
        
        if lastOffset - current > 0 {
            print("show")
        } else {
            print("close")
        }
        
        lastOffset = current
    }
}

extension FeedVC: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return withWidth * 1.4
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let text = viewModel.data.value[indexPath.row].name
        return text.height(withConstrainedWidth: withWidth-100,
                           font: .lil_14) + 10
    }
}
