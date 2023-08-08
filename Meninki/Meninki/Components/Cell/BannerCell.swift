//
//  BannerCell.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import UIKit
import EasyPeasy

class BannerCell: UICollectionViewCell {
    
    static let id = "BannerCell"
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 6)
    
    let img = UIImageView(contentMode: .scaleAspectFit,
                          cornerRadius: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Top(), Leading(), Trailing(), Width(DeviceDimensions.width), Height(100)
        ])
    }
}
