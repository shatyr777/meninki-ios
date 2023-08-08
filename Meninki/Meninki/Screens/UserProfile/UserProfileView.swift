//
//  UserProfileView.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import UIKit
import EasyPeasy

class UserProfileView: BaseView {
    
    var topBg = UIView()
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10)
    
    var header = Header(title: "profile".localized())
    
    var collectionView = PinterestCollectionView()
  
    var fab = IconBtn(icon: UIImage(named: "fab-add"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(topBg)
        topBg.backgroundColor = .lowContrast
        topBg.easy.layout([
            Top(), Leading(), Trailing(), Height(DeviceDimensions.topInset)
        ])
        
        addSubview(contentStack)
        contentStack.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(8), Trailing(8), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
        
        addSubview(fab)
        fab.isHidden = true
        fab.easy.layout([
            Bottom(30).to(safeAreaLayoutGuide, .bottom), Trailing(20), Size(60)
        ])
        
        contentStack.addArrangedSubviews([header, collectionView])
    }
}
