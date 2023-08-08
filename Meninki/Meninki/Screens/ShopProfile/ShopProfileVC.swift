//
//  ShopProfileVC.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import UIKit
import EasyPeasy

class ShopProfileVC: UIViewController {

    let viewModel = ShopProfileVM()
    
    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var header = ShopProfileHeader()
    var headerHeight: CGFloat = 0
    
    var mainView: UserProfileView {
        return view as! UserProfileView
    }
    
    override func loadView() {
        super.loadView()
        view = UserProfileView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.refreshControl = UIRefreshControl()
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        setupView()
        setupBindings()
        setupCallbacks()
        viewModel.getShop()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if headerHeight == 0  {
            headerHeight = header.contentStack.bounds.size.height
            mainView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    func setupView(){
        let l = mainView.collectionView.collectionViewLayout as? PinterestLayout
        l?.delegate = self

        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.fab.isHidden = !AccUserDefaults.shopIds.contains(viewModel.id)
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
        
        viewModel.shop.bind { [weak self] shop in
            self?.header.delegate = self
            self?.header.setupData(data: shop)
            self?.header.setupCallbacks()
        }

        viewModel.data.bind { [weak self] toShow in
            self?.mainView.collectionView.reloadData()
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.fab.clickCallback = { [weak self] in
            self?.navigationController?.pushViewController(AddProductVC(), animated: true)
        }
        
        mainView.noContent.btn.clickCallback = { [weak self] in
            self?.viewModel.getShop()
        }
        
        mainView.noConnection.btn.clickCallback = { [weak self] in
            self?.viewModel.getShop()
        }
    }
    
    func openMoreBS(product: Card){
//        let vc = FeedMoreBS()
//        vc.delegate = self
//        vc.data = post
//        vc.modalPresentationStyle = .custom
//        vc.transitioningDelegate = sheetTransitioningDelegate
//        present(vc, animated: true)
    }
    
    @objc func refresh(){
        mainView.collectionView.refreshControl?.endRefreshing()
        viewModel.getShop()
    }
}

extension ShopProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "View", for: indexPath)
        v.addSubview(header)
        header.easy.layout(Edges())
        return v
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.id, for: indexPath) as! FeedCell
        let product = viewModel.data.value[indexPath.row]
        cell.setupData(data: product)
        cell.moreBtn.clickCallback = { [weak self] in
            self?.openMoreBS(product: product)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductVC()
        vc.viewModel.id = viewModel.data.value[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: headerHeight == 0 ? DeviceDimensions.height : header.contentStack.bounds.size.height + 10)
    }
}

extension ShopProfileVC: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return withWidth * 1.4
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let text = viewModel.data.value[indexPath.row].name ?? ""
        return text.height(withConstrainedWidth: withWidth-100,
                           font: .lil_14) + 60
    }
}

//extension ShopProfileVC: FeedBSDelegate {
//    func like(id: String?) {
//        guard let id = id else { return }
//        let params = ChangeLike(id: id, isIncrease: true)
//        viewModel.postVM?.changeRating(params: params)
//    }
//
//    func dislike(id: String?) {
//        guard let id = id else { return }
//        let params = ChangeLike(id: id, isIncrease: nil)
//        viewModel.postVM?.changeRating(params: params)
//    }
//
//    func copyPath(path: String?) {
//        if (path ?? "").isEmpty == true {
//            showToast(message: "copy_failed".localized())
//        } else {
//            UIPasteboard.general.string = path ?? ""
//            showToast(message: "copied".localized())
//        }
//    }
//
//    func goToProduct(productId: String?) {
//        let vc = ProductVC()
//        vc.viewModel.id = productId ?? ""
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func goToUserProfile(userId: String?) {
//        let vc = UserProfileVC()
//        vc.viewModel.id = userId ?? ""
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func goToShopProfile(shopId: String?) {
//        let vc = ShopProfileVC()
//        vc.viewModel.id = shopId ?? ""
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func complain(id: String?) {
//        print("OPEN COMPLAIN")
//    }
//}

extension ShopProfileVC: ShopProfileClicks {
    func openSubscribers() {
        let vc = SubscriberListVC(id: viewModel.id, type: .userSubscribersOfShop)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSettings() {
        let vc = AddShopVC()
        vc.viewModel.shop = viewModel.shop.value
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openContacts() {
        
    }
    
    func openOrders() {
        let vc = ShopOrdersVC()
        vc.shopId = viewModel.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func subscribe() {
        viewModel.changeSubscriptionStatus(params: ChangeLike(id: viewModel.id, isSubscribe: true))
    }
    
    func unsubscribe() {
        viewModel.changeSubscriptionStatus(params: ChangeLike(id: viewModel.id, isSubscribe: false))
    }
}
