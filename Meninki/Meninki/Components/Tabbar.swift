//
//  Tabbar.swift
//  Meninki
//
//  Created by Shirin on 3/30/23.
//

import UIKit
import EasyPeasy
import Kingfisher

class Tabbar: UIView {

    var contentBg = UIView()
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 14,
                                   edgeInsets: UIEdgeInsets(edges: 10))
    
    let home = TabbarItem(img: "home-empty", selectedImg: "home-filled", isSelected: true)
    
    let category = TabbarItem(img: "category-empty", selectedImg: "category-filled")
    
    let cart = TabbarItem(img: "cart-empty", selectedImg: "cart-filled")
    
    let profile = TabbarItem(img: "profile", selectedImg: "profile-filled",
                             imgPath: AccUserDefaults.avatar)
    
    var tabs: [TabbarItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupContent()
        
        tabs = [home, category, cart, profile]
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Edges()
        ])
    }
    
    func setupContent(){
        contentBg = contentStack.addBackground(color: .white,
                                               cornerRadius: 32)
        
        contentStack.addArrangedSubviews([home,
                                          category,
                                          cart,
                                          profile])

        contentBg.layer.shadowColor = UIColor.white.withAlphaComponent(0.08).cgColor
        contentBg.layer.shadowRadius = 30
        contentBg.layer.shadowOpacity = 1
    }
}

class TabbarItem: UIView {
    
    var icon = UIImageView(contentMode: .scaleAspectFill,
                           cornerRadius: 0,
                           backgroundColor: .clear)
        
    var isSelected: Bool = false {
        didSet {
            if isSelected == oldValue {  return }
            setupState()
        }
    }
    
    var selectedImg: String!
    var img: String!
    var imgPath: String?
    
    var clickCallback: ( ()->() )?
    
    init(img: String, selectedImg: String,
         imgPath: String? = nil, isSelected: Bool = false){
        super.init(frame: .zero)
        
        self.img = img
        self.imgPath = imgPath
        self.selectedImg = selectedImg
        self.clipsToBounds = true
        icon.clipsToBounds = true
        if imgPath != nil {
            icon.kf.setImage(with: ApiPath.getUrl(path: imgPath ?? ""))
            setupView(padding: 0)
        } else {
            setupView(padding: 12)
        }
        
        self.isSelected = isSelected
        setupState()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(padding: CGFloat){
        addSubview(icon)
        icon.easy.layout([
            Edges(padding)
        ])
        
        layer.cornerRadius = 22
        easy.layout(Size(44))
    }
    
    func setupState(){
        if isSelected {
            setupSelectedState()
        } else {
            setupInactiveState()
        }
    }
    
    func setupInactiveState(){
        backgroundColor = .onBgLc
        if imgPath != nil { return }
        icon.image = UIImage(named: img ?? "")
    }

    func setupSelectedState(){
        backgroundColor = .contrast
        if imgPath != nil { return }
        icon.image = UIImage(named: selectedImg ?? "")
    }
    
    @objc func click(){
        isSelected = true
        clickCallback?()
    }
}
