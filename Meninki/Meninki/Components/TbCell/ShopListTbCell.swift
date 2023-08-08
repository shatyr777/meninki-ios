//
//  ShopListTbCell.swift
//  Meninki
//
//  Created by Shirin on 4/30/23.
//

import UIKit
import EasyPeasy

class ShopListTbCell: UITableViewCell {

    static let id = "ShopListTbCell"
    
    weak var delegate: MainClicksDelegate?
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 6,
                                   edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
    
    var title = UILabel(font: .h2,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0,
                        text: "shops".localized())

    var collectionView = UICollectionView(scrollDirection: .horizontal,
                                          itemSize: CGSize(width: 100, height: 140))
    
    var data: [Cart] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        collectionView.register(ShopDataCell.self, forCellWithReuseIdentifier: ShopDataCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self

        contentView.addSubview(contentStack)
        contentStack.addArrangedSubviews([title, collectionView])
        contentStack.easy.layout(Edges())
        collectionView.easy.layout(Height(140))
    }
}

extension ShopListTbCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopDataCell.id, for: indexPath) as! ShopDataCell
        let data = data[indexPath.item]
        cell.setupData(imgPath: data.shop.imagePath, name: data.shop.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShopProfileVC()
        vc.viewModel.id = data[indexPath.item].id
        delegate?.openVC(vc: vc)
    }
}
