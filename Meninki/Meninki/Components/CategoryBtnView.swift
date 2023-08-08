//
//  CategoryBtnView.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit
import EasyPeasy

class CategoryBtnView: UIView {

    var data: [Category] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedAtInd: ((Int)->())?
    
    var collectionView = UICollectionView(scrollDirection: .horizontal,
//                                          estimatedItemSize: CGSize(width: 100, height: 40),
                                          minimumLineSpacing: 10,
                                          minimumInteritemSpacing: 10,
                                          contentInsets: UIEdgeInsets(hEdges: 16),
                                          backgroundColor: .clear,
                                          isPagingEnabled: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(CategoryBtnCell.self, forCellWithReuseIdentifier: CategoryBtnCell.id)
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(collectionView)
        collectionView.easy.layout([
            Edges(), Height(40)
        ])
    }
}

extension CategoryBtnView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryBtnCell.id, for: indexPath) as! CategoryBtnCell
        cell.name.text = data[indexPath.item].getTitle()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAtInd?(indexPath.item)
    }
}
