//
//  UserProfileHeader.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class UserProfileHeader: UICollectionReusableView {
    
    static let id = "UserProfileHeader"

    weak var delegate: UserProfileClicks?
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(hEdges: 6, vEdges: 10))
    
    var topWhiteStackWrapper = UIView()
    
    var topWhiteStack = UIStackView(axis: .vertical,
                                    alignment: .fill,
                                    spacing: 1)
    
    var username = ProfileDataStack()
    
    var subscribeBtn = ProfileSubscribeBtn()

    var updateProfileBtn = ProfileHorizontalBtn(title: "update_profile".localized(),
                                           icon: "settings")
    
    var settingsBtn = ProfileHorizontalBtn(title: "settings".localized(),
                                           icon: "settings")

    var collectionView = UICollectionView(scrollDirection: .horizontal,
                                          itemSize: CGSize(width: 100, height: 140))

    var subscriptionsStack = UIStackView(axis: .horizontal,
                                         alignment: .fill,
                                         spacing: 10,
                                         distribution: .fillEqually)
    
    var subscribersCount = ProfileDataBlock(title: "subscribers".localized())
    
    var subscribesCount = ProfileDataBlock(title: "subscribes".localized())

    var isOwn = false {
        didSet {
            let f = isOwn ? setupOwn : setupOther
            f()
        }
    }

    var shops: [User] = [] {
        didSet {
            collectionView.isHidden = shops.isEmpty && !isOwn
            collectionView.reloadData()
        }
    }

    var clickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Top(), Leading(), Trailing()
        ])
        collectionView.easy.layout(Height(140))
        
        collectionView.register(ShopDataCell.self, forCellWithReuseIdentifier: ShopDataCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        topWhiteStackWrapper.layer.cornerRadius = 10
        topWhiteStackWrapper.backgroundColor = .bg
        topWhiteStackWrapper.clipsToBounds = true
        topWhiteStackWrapper.addSubview(topWhiteStack)
        topWhiteStack.easy.layout(Edges())
    }
    
    func setupOwn(){
        contentStack.addArrangedSubviews([topWhiteStackWrapper,
                                          collectionView,
                                          subscriptionsStack])
        
        topWhiteStack.addArrangedSubviews([username, updateProfileBtn, settingsBtn])
        subscriptionsStack.addArrangedSubviews([subscribesCount, subscribersCount])
    }
    
    func setupOther(){
        contentStack.addArrangedSubviews([topWhiteStackWrapper,
                                          subscriptionsStack])
        
        topWhiteStack.addArrangedSubviews([username, subscribeBtn])
        subscriptionsStack.addArrangedSubviews([subscribesCount, subscribersCount])
    }
    
    func setupData(data: UserProfile?){
        guard let data = data else { return }
        print(data)
        isOwn = data.id == AccUserDefaults.id
        shops = data.shops ?? []
        username.name.text = data.name
        username.username.text = data.userName
        
        print( ApiPath.getUrl(path: data.imagePath ?? "") )
        username.img.kf.setImage(with: ApiPath.getUrl(path: data.imagePath ?? ""))
        subscribeBtn.isSubscribed = data.isSubscribed ?? false
        subscribesCount.setupCount(data.subscriptionCount)
        subscribersCount.setupCount(data.subscriberCount)
    }
    
    func setupCallbacks(){
        subscribeBtn.subscribeClickCallback = { [weak self] in
            self?.delegate?.subscribe()
        }
        
        subscribeBtn.unsubscribeClickCallback = { [weak self] in
            self?.delegate?.unsubscribe()
        }
        
        settingsBtn.clickCallback = { [weak self] in
            self?.delegate?.openSettings()
        }
        
        subscribesCount.clickCallback = { [weak self] in
            self?.delegate?.openSubscribes()
        }
        
        subscribersCount.clickCallback = { [weak self] in
            self?.delegate?.openSubscribers()
        }
        
        updateProfileBtn.clickCallback = { [weak self] in
            self?.delegate?.openEditProfile()
        }
    }
}

extension UserProfileHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopDataCell.id, for: indexPath) as! ShopDataCell
        if indexPath.item < shops.count {
            let data = shops[indexPath.item]
            cell.setupData(imgPath: data.imgPath, name: data.name)
        } else {
            cell.setupAdd()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < shops.count {
            delegate?.openShopProfile(id: shops[indexPath.item].id)
        } else {
            delegate?.openAddShop()
        }
    }
}
