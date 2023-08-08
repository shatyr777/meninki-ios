//
//  ImageListView.swift
//  Meninki
//
//  Created by Shirin on 4/25/23.
//

import UIKit
import EasyPeasy

class ImageListView: UIView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 2)
    
    var collectionView: UICollectionView!
    
    var pageControlWrapper = UIView()

    var pageControl: UIPageControl = {
        let p = UIPageControl()
        p.hidesForSinglePage = true
        p.pageIndicatorTintColor = .neutralDark
        p.currentPageIndicatorTintColor = .black
        if #available(iOS 14.0, *) {
            p.backgroundStyle = .minimal
        }
        return p
    }()
    
    var data: [Image] = [] {
        didSet {
            collectionView.reloadData()
            pageControl.numberOfPages = data.count
        }
    }

    var size: CGSize!
    
    init(size: CGSize){
        super.init(frame: .zero)
        collectionView = UICollectionView(scrollDirection: .horizontal,
                                          itemSize: size,
                                          isPagingEnabled: true)
        self.size = size
        setupView()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.id)
        collectionView.easy.layout(Height(size.height))
        
        pageControlWrapper.addSubview(pageControl)
        pageControl.easy.layout([
            Top(), Bottom(), CenterX(), Height(26)
        ])

        addSubview(contentStack)
        contentStack.easy.layout( Edges() )
        contentStack.addArrangedSubviews([collectionView,
                                          pageControlWrapper])
    }
}

extension ImageListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.id, for: indexPath) as! ImageCell
        cell.img.kf.setImage(with: ApiPath.getUrl(path: data[indexPath.item].path ?? ""))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCount = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = currentCount
    }
}
