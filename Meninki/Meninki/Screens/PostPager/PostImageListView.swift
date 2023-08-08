//
//  PostImageListView.swift
//  Meninki
//
//  Created by Shirin on 4/22/23.
//

import UIKit
import EasyPeasy
import Kingfisher

class PostImageListView: UIStackView {

    var data: [Media]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let collectionView = UICollectionView(scrollDirection: .horizontal,
                                          estimatedItemSize: .zero,
                                          minimumLineSpacing: 2,
                                          minimumInteritemSpacing: 2,
                                          isPagingEnabled: true)
        
    var pageChanged: ( (Int)->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self

        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addArrangedSubview(collectionView)
        collectionView.easy.layout(Height(DeviceDimensions.safeAreaHeight))
    }
}

extension PostImageListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.id, for: indexPath) as! ImageCell
        let path = data?[indexPath.item].path
        cell.img.kf.setImage(with: ApiPath.getUrl(path:  path ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DeviceDimensions.width-8,
                      height: DeviceDimensions.safeAreaHeight-80)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = Int(scrollView.contentOffset.x )
        let width = Int(scrollView.bounds.width)
        if width != 0 {
            pageChanged?(Int(offset/width))
        }
    }
}
