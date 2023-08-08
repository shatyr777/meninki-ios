//
//  ImageCell.swift
//  Meninki
//
//  Created by Shirin on 4/22/23.
//

import UIKit
import EasyPeasy

class ImageCell: UICollectionViewCell {
    
    static let id = "ImageCell"
    
    var img = ZoomableImageView(contentMode: .scaleAspectFit,
                                cornerRadius: .zero,
                                image: nil,
                                backgroundColor: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(img)
        img.easy.layout(Edges())
    }
}
