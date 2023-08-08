//
//  ProductFooter.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import UIKit
import EasyPeasy

class ProductFooter: UIView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 14,
                                   edgeInsets: UIEdgeInsets(hEdges: 16, vEdges: 14))
    
    var priceStack = UIStackView(axis: .vertical,
                                 alignment: .fill,
                                 spacing: 6)
    
    var oldPriceStack = UIStackView(axis: .horizontal,
                                    alignment: .fill,
                                    spacing: 10)
    
    var currentPrice = UILabel(font: .sb_16,
                               color: .contrast,
                               alignment: .left,
                               numOfLines: 0)
    
    var oldPrice = UILabel(font: .lil_12,
                           color: .contrast,
                           alignment: .left,
                           numOfLines: 0)
    
    var discount = UILabel(font: .lil_12,
                           color: .lukas,
                           alignment: .left,
                           numOfLines: 0)

    var likeBtn: IconBtn = {
        let b = IconBtn(icon: UIImage(named: "heart-24"),
                        tintColor: .contrast)
        b.layer.cornerRadius = 10
        b.backgroundColor = .white
        b.easy.layout(Size(48))
        return b
    }()
    
    var cartBtn: IconBtn = {
        let b = IconBtn(icon: UIImage(named: "cart-filled"),
                        tintColor: .white)
        b.layer.cornerRadius = 10
        b.backgroundColor = .contrast
        b.easy.layout(Size(48))
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .onBgLc
        
        setupView()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Top(), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
    }
    
    func setupContentStack(){
        contentStack.addArrangedSubviews([priceStack,
                                          likeBtn,
                                          cartBtn])
        
        priceStack.addArrangedSubviews([currentPrice,
                                        oldPriceStack])
        
        oldPriceStack.addArrangedSubviews([discount,
                                           oldPrice])
        
        discount.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func setupData(data: Product?){
        guard let data = data else { return }
        let isLiked = data.rating?.userRating?.keys.contains(where: {$0 == AccUserDefaults.id}) ?? false
        likeBtn.setImage(UIImage(named: isLiked ? "heart-filled-24" : "heart-24"), for: .normal)
        
        if data.discountPrice != data.price {
            oldPrice.text = "\(data.price ?? 0) TMT"
            currentPrice.text = "\(data.discountPrice ?? 0) TMT"
            if data.discountPrice != 0 {
                let percent = Int(100*(data.discountPrice ?? 1)/(data.price ?? 1))
                discount.text = "\(100 - percent)%"
            }
        } else {
            oldPrice.text = ""
            discount.text = ""
            currentPrice.text = "\(data.price ?? 0) TMT"
        }
    }
}
