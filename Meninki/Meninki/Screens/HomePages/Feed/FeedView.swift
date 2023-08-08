//
//  FeedView.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit
import EasyPeasy

class FeedView: BaseView {

    var header = FeedHeader(title: "posts".localized())
    
    var simpleHeader = Header(title: "")
    
    var search = SearchBar()
    
    var filterBtn = IconBtn(icon: UIImage(named: "filter"))

    var collectionView = PinterestCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
                
        addSubview(collectionView)
        collectionView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom()
        ])
    }
    
    func setupWithColView(){
        header.removeFromSuperview()
        collectionView.easy.layout(Edges())
    }
    
    func setupWithSearch(){
        header.removeFromSuperview()
        
        addSubview(simpleHeader)
        simpleHeader.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        addSubview(filterBtn)
        filterBtn.easy.layout([
            Top(10).to(simpleHeader, .bottom), Trailing(8)
        ])
        
        addSubview(search)
        search.easy.layout([
            Top(10).to(simpleHeader, .bottom), Leading(8), Trailing(8).to(filterBtn)
        ])

        addSubview(collectionView)
        collectionView.easy.layout([
            Top(10).to(search, .bottom), Leading(), Trailing(), Bottom()
        ])
        
        noContent.easy.layout([
            Top().to(search, .bottom), Leading(), Trailing(), Bottom()
        ])
        
        noConnection.easy.layout([
            Top().to(search, .bottom), Leading(), Trailing(), Bottom()
        ])
    }
}
