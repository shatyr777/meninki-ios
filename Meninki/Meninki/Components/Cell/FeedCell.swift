//
//  FeedCell.swift
//  Meninki
//
//  Created by Shirin on 3/30/23.
//

import UIKit
import EasyPeasy

class FeedCell: UICollectionViewCell {
    
    static let id = "FeedCell"
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 6)
    
    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 20,
                          image: nil,
                          backgroundColor: .neutralDark)
    
    var btnStack = UIStackView(axis: .horizontal,
                               alignment: .fill,
                               spacing: 10,
                               edgeInsets: UIEdgeInsets(edges: 10))

    var likeBtn = FeedCellBtn(icon: UIImage(named: "heart")?
                                    .withRenderingMode(.alwaysTemplate),
                              axis: .horizontal)
    
    var viewBtn = FeedCellBtn(icon: UIImage(named: "play")?
                                    .withRenderingMode(.alwaysTemplate),
                              axis: .horizontal)
    
    var textStack = UIStackView(axis: .horizontal,
                                alignment: .top,
                                spacing: 10)
    
    var moreBtn = IconBtn(icon: UIImage(named: "h-more"))

    var desc = UILabel(font: .lil_14,
                       color: .contrast,
                       alignment: .left,
                       numOfLines: 0,
                       text: "qwerty qwerty qwerty qwerty qwerty qwerty qwerty qwerty qwerty qwerty qwerty qwerty")
    
    var priceStack = UIStackView(axis: .horizontal,
                                 alignment: .center,
                                 spacing: 2)
    
    var price = UILabel(font: .lil_14_b,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0,
                        text: "123 TMT")
    
    var discount = UILabel(font: .lil_12,
                           color: .contrast,
                           alignment: .right,
                           numOfLines: 0,
                           text: "123 TMT")

    var oldPrice = UILabel(font: .lil_14,
                           color: .neutralDark,
                           alignment: .left,
                           numOfLines: 0,
                           text: "123 TMT")

    let width = DeviceDimensions.width/2-16
    
    let spacer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentStack.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longClick)))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        moreBtn.easy.layout([Width(30), Height(20)])

        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Edges()
        ])
        
        img.addSubview(btnStack)
        btnStack.easy.layout([
            Bottom(), Leading(), Trailing()
        ])
        
        img.easy.layout([
            Width(width), Height(width*1.4)
        ])
        

        contentStack.addArrangedSubviews([img,
                                          textStack])
        
        btnStack.addArrangedSubviews([likeBtn,
                                      UIView()])
        
        textStack.addArrangedSubviews([desc,
                                       moreBtn])
        
        priceStack.addArrangedSubviews([price,
                                        discount])

    }
    
    func setupData(data: Card){
        img.kf.setImage(with: ApiPath.getUrl(path: (data.images.first ?? "") ?? ""))
        desc.text = data.name
        likeBtn.count.text = "\(data.rating?.total ?? 0)"
        contentStack.addArrangedSubview(priceStack)
        oldPrice.removeFromSuperview()
        spacer.removeFromSuperview()
        price.text = "\(data.price) TMT"
        discount.text = ""

        if data.discountPrice != 0 {
            contentStack.addArrangedSubviews([priceStack, oldPrice])
            oldPrice.setStrikeThroughText("\(data.discountPrice) TMT")
            price.text = "\(data.price) TMT"
            
            if data.discountPrice != 0 {
                let percent = Int(100*data.price/data.discountPrice)
                discount.text = "\(100 - percent)%"
            }
        }
        
        contentStack.addArrangedSubview(spacer)
    }
    
    func setupData(data: Post){
        spacer.removeFromSuperview()
//        if data.imagePath != nil {
//
//        }
        img.kf.setImage(with: ApiPath.getUrl(path: data.medias.first?.preview ?? data.medias.first?.path ?? ""))
        print( ApiPath.getUrl(path: data.medias.first?.preview ?? data.medias.first?.path ?? ""))
        desc.text = data.description
        likeBtn.count.text = "\(data.rating?.total ?? 0)"
        priceStack.removeFromSuperview()
        oldPrice.removeFromSuperview()
        contentStack.addArrangedSubview(spacer)
    }
    
    @objc func longClick(){
        UIImpactFeedbackGenerator().impactOccurred()
        moreBtn.clickCallback?()
    }
}
