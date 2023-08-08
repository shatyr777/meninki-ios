//
//  MediaListView.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit
import EasyPeasy

class MediaListView: UIView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10)
    
    var title = UILabel(font: .sb_16,
                        color: .contrast,
                        text: "media".localized())
    
    var collectionView: UICollectionView!

    var itemSize: CGFloat = 0
    
    var data: [UIImage?] = [] {
        didSet {
            setupHeight()
        }
    }
    
    var didSelect: ( (_ ind: Int)->() )?
    var didRemove: ( (_ ind: Int)->() )?
    var addClick: ( ()->() )?
    
    init(columns: CGFloat){
        super.init(frame: .zero)
        itemSize = (DeviceDimensions.width-38-(columns*10))/columns
        
        setupView()
        setupHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        collectionView = UICollectionView(scrollDirection: .vertical,
                                          itemSize: CGSize(width: itemSize,
                                                           height: itemSize),
                                          minimumLineSpacing: 10,
                                          minimumInteritemSpacing: 10)
        collectionView.register(AddMediaCell.self, forCellWithReuseIdentifier: AddMediaCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([title,
                                          collectionView])
    }
    
    func setupHeight(){
        let count = ceil(Double(data.count+1)/2.0)
        collectionView.easy.layout(Height(count*itemSize+count*10))
        collectionView.reloadData()
    }
}

extension MediaListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMediaCell.id, for: indexPath) as! AddMediaCell
        
        if data.count != indexPath.item {
            cell.setupNormal()
            cell.img.image = data[indexPath.item]
            cell.closeBtn.clickCallback = { [weak self] in
                self?.didRemove?(indexPath.item)
            }
        } else {
            cell.setupAdd()
            cell.addBtn.clickCallback = { [weak self] in
                self?.addClick?()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(indexPath.item)
    }
}
