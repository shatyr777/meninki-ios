//
//  UserProfileVC.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import UIKit
import EasyPeasy

class UserProfileVC: UIViewController {

    static var update = false
    
    var viewModel = UserProfileVM()
    
    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var header = UserProfileHeader()
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
        
        setupView()
        setupBindings()
        setupCallbacks()
        viewModel.getUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.collectionView.refreshControl = UIRefreshControl()
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        if viewModel.isOwn && UserProfileVC.update {
            UserProfileVC.update = false
            viewModel.getUser()
        }
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
        mainView.header.isHidden = viewModel.isOwn
        mainView.topBg.isHidden = viewModel.isOwn
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
        
        viewModel.user.bind { [weak self] user in
            self?.header.delegate = self
            self?.header.setupData(data: user)
            self?.header.setupCallbacks()
        }

        viewModel.postVM?.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }

//        viewModel.postVM?.noContent.bind { [weak self] toShow in
//            self?.mainView.noContent(toShow)
//        }

        viewModel.postVM?.data.bind { [weak self] toShow in
            self?.mainView.collectionView.reloadData()
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.noContent.btn.clickCallback = { [weak self] in
            self?.viewModel.getUser()
        }
        
        mainView.noConnection.btn.clickCallback = { [weak self] in
            self?.viewModel.getUser()
        }
    }
    
    func openMoreBS(post: Post){
        let vc = FeedMoreBS()
        vc.delegate = self
        vc.data = post
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        present(vc, animated: true)
    }
    
    @objc func refresh(){
        mainView.collectionView.refreshControl?.endRefreshing()
        viewModel.getUser()
    }
}

extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.postVM?.data.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "View", for: indexPath)
        v.addSubview(header)
        header.easy.layout(Edges())
        return v
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.id, for: indexPath) as! FeedCell
        guard let post = viewModel.postVM?.data.value[indexPath.row] else { return UICollectionViewCell ()}
        cell.setupData(data: post)
        cell.moreBtn.clickCallback = { [weak self] in
            self?.openMoreBS(post: post)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vm = viewModel.postVM else { return }
        let vc = PostPagerVC(viewModel: vm,current: indexPath.item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: headerHeight == 0 ? DeviceDimensions.height : header.contentStack.bounds.size.height + 10)
    }
}

extension UserProfileVC: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return withWidth * 1.4
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let text = viewModel.postVM?.data.value[indexPath.row].name ?? ""
        return text.height(withConstrainedWidth: withWidth-100,
                           font: .lil_14) + 10
    }
}

extension UserProfileVC: FeedBSDelegate {
    func like(id: String?) {
        guard let id = id else { return }
        let params = ChangeLike(id: id, isIncrease: true)
        viewModel.postVM?.changeRating(params: params)
    }
    
    func dislike(id: String?) {
        guard let id = id else { return }
        let params = ChangeLike(id: id, isIncrease: nil)
        viewModel.postVM?.changeRating(params: params)
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

extension UserProfileVC: UserProfileClicks {
    func openEditProfile() {
        let vc = EditProfileVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSubscribers() {
        let vc = SubscriberListVC(id: viewModel.id, type: .userSubscribersOfUser)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSubscribes() {
        let vc = SubscribesPagerVC()
        vc.id = viewModel.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openShopProfile(id: String?) {
        let vc = ShopProfileVC()
        vc.viewModel.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSettings() {
        let vc = SettingsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openAddShop() {
        let vc = AddShopVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func subscribe() {
        viewModel.changeSubscriptionStatus(params: ChangeLike(id: viewModel.id, isSubscribe: true))
    }
    
    func unsubscribe() {
        viewModel.changeSubscriptionStatus(params: ChangeLike(id: viewModel.id, isSubscribe: true))
    }
}
