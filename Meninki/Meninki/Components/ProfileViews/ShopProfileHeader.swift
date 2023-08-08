//
//  ShopProfileHeader.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import UIKit
import EasyPeasy

class ShopProfileHeader: UICollectionReusableView {
        
    static let id = "ShopProfileHeader"
    
    weak var delegate: ShopProfileClicks?
    
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
    
    var settingsBtn = ProfileHorizontalBtn(title: "shop_settings".localized(),
                                           icon: "settings")
    
    var contactsBtn = ProfileHorizontalBtn(title: "contacts".localized(),
                                           icon: "settings")
    
    var subscribersCount = ProfileDataBlock(title: "subscribers".localized())
    
    var productCount = ProfileDataBlock(title: "products".localized())
    
    var ratingCount = ProfileDataBlock(title: "total_rating".localized(), axis: .horizontal)
    
    var orderCount = ProfileDataBlock(title: "orders".localized())
    
    var visitersCount = ProfileDataBlock(title: "visiter".localized())
    
    var desc = UILabel(font: .lil_14,
                       color: .contrast)
    
    var isOwn = false {
        didSet {
            let f = isOwn ? setupOwn : setupOther
            f()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
//        setupCallbacks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        let v = UIView()
        addSubview(v)
        v.easy.layout([
            Top().to(contentStack, .bottom), Bottom(), Leading(), Trailing()
        ])

        contactsBtn.layer.cornerRadius = 10
        topWhiteStackWrapper.layer.cornerRadius = 10
        topWhiteStackWrapper.backgroundColor = .bg
        topWhiteStackWrapper.clipsToBounds = true
        topWhiteStackWrapper.addSubview(topWhiteStack)
        topWhiteStack.easy.layout(Edges())
    }
    
    func setupOwn(){
        contentStack.addArrangedSubviews([topWhiteStackWrapper,
                                          line([subscribersCount, productCount]),
                                          ratingCount,
                                          line([orderCount, visitersCount]),
                                          desc
                                         ])
        
        topWhiteStack.addArrangedSubviews([username,
                                           settingsBtn])
    }
    
    func setupOther(){
        contentStack.addArrangedSubviews([topWhiteStackWrapper,
                                          line([subscribersCount, productCount]),
                                          desc
                                         ])
        
        topWhiteStack.addArrangedSubviews([username,
                                           subscribeBtn])
    }
    
    func line(_ views: [UIView])-> UIView {
        let stack = UIStackView(axis: .horizontal,
                                alignment: .fill,
                                spacing: 10,
                                distribution: .fillEqually)
        stack.addArrangedSubviews(views)
        return stack
    }
    
    func setupData(data: UserProfile?){
        guard let data = data else { return }
        isOwn = AccUserDefaults.shopIds.contains(data.id)
        username.name.text = data.name
        username.username.text = data.userName
        username.img.kf.setImage(with: ApiPath.getUrl(path: data.imagePath ?? ""))
        subscribeBtn.isSubscribed = data.isSubscribed ?? false
        subscribersCount.setupCount(data.subscriberCount)
        productCount.setupCount(data.totalProduct)
        ratingCount.setupCount(data.placeInRating)
        orderCount.setupCount(data.orderCount)
        visitersCount.setupCount(data.visiterCount)
        desc.text = data.description
    }
    
    func setupCallbacks(){
        subscribeBtn.subscribeClickCallback = { [weak self] in
            self?.delegate?.subscribe()
        }
        
        subscribeBtn.unsubscribeClickCallback = { [weak self] in
            self?.delegate?.unsubscribe()
        }
        
        contactsBtn.clickCallback = { [weak self] in
            self?.delegate?.openContacts()
        }
        
        settingsBtn.clickCallback = { [weak self] in
            self?.delegate?.openSettings()
        }
                
        subscribersCount.clickCallback = { [weak self] in
            self?.delegate?.openSubscribers()
        }
        
        orderCount.clickCallback = { [weak self] in
            self?.delegate?.openOrders()
        }
    }
}
