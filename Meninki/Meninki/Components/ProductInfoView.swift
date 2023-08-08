//
//  ProductInfoView.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit
import EasyPeasy

class ProductInfoView: UIView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(edges: 14))
    
    var title = UILabel(font: .sb_16,
                        color: .contrast)
    
    var shopStack = UIStackView(axis: .horizontal,
                                alignment: .fill,
                                spacing: 10,
                                edgeInsets: UIEdgeInsets(edges: 10),
                                backgroundColor: .bg,
                                cornerRadius: 10)
    
    var profileImg = ProfileImg(size: 26)
    
    var shopName = UILabel(font: .lil_14,
                           color: .contrast)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lowContrast.cgColor
        backgroundColor = .white

        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([title, shopStack])
        shopStack.addArrangedSubviews([profileImg, shopName])
    }
    
    func setupData(data: Product?){
        guard let data = data else { return }
        title.text = data.name
        shopName.text = data.shop?.name
        profileImg.kf.setImage(with: ApiPath.getUrl(path: data.shop?.imgPath ?? ""))
    }
}
