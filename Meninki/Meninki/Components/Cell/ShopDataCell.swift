//
//  ShopDataCell.swift
//  Meninki
//
//  Created by Shirin on 4/30/23.
//

import UIKit
import EasyPeasy

class ShopDataCell: UICollectionViewCell {
    
    static let id = "ShopDataCell"
    let contentStack = UIStackView(axis: .vertical,
                                   alignment: .center,
                                   spacing: 6,
                                   edgeInsets: UIEdgeInsets(edges: 10))
    
    let img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 40)
    

    let title = UILabel(font: .lil_12,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 2)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout(Edges())
        img.easy.layout(Size(80))
        contentStack.addArrangedSubviews([img, title])
    }
    
    func setupData(imgPath: String?, name: String?){
        img.kf.setImage(with: ApiPath.getUrl(path: imgPath ?? ""))
        title.text = name
    }
    
    func setupAdd(){
        img.image = UIImage(named: "plus-80")
        title.text = "add_shop".localized()
    }
}
