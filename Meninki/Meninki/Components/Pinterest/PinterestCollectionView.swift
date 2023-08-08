//
//  PinterestCollectionView.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit

class PinterestCollectionView: UICollectionView {
    
    init(){
        let layout = PinterestLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.id)
        register(UICollectionReusableView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: "View")
        contentInset.bottom = 70
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        keyboardDismissMode = .onDrag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContetnSizedPinterestCollectionView: UICollectionView {
    
    init(){
        let layout = PinterestLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.id)
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.contentSize.width,
                      height: self.contentSize.height)
    }
}
