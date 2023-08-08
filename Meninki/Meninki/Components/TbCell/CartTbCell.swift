//
//  CartTbCell.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class CartTbCell: UITableViewCell {
    
    static let id = "CartTbCell"
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
    
    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 10)
    
    var titleStack = UIStackView(axis: .vertical,
                                 alignment: .fill,
                                 spacing: 10)
    
    var name = UILabel(font: .lil_14, color: .contrast)
    
    var chars = UILabel(font: .lil_14, color: .textLc)
    
    var stepperStack = UIStackView(axis: .horizontal,
                                   alignment: .bottom,
                                   spacing: 10)
    
    var stepper = Stepper()
    
    var priceStack = UIStackView(axis: .vertical,
                                 alignment: .fill,
                                 spacing: 2)

    var currentPrice = UILabel(font: .lil_14_b,
                               color: .contrast)
    
    var oldPrice = UILabel(font: .lil_12,
                           color: .neutralDark,
                           alignment: .right)
    
    var inCartCountChanged: ( (_ count: Int)->() )?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupView()
        setupCallbacks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout(Edges())
        img.easy.layout([
            Width(DeviceDimensions.width/3),
            Height(DeviceDimensions.width/2.5)
        ])
        
        contentStack.addArrangedSubviews([img, titleStack])
        titleStack.addArrangedSubviews([name, chars, UIView(), stepperStack])
        stepperStack.addArrangedSubviews([stepper, UIView(), priceStack])
        priceStack.addArrangedSubviews([oldPrice, currentPrice])
    }
    
    func setupCallbacks(){
        stepper.plusBtn.clickCallback = { [weak self] in
            self?.stepper.count += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self?.inCartCountChanged?(self?.stepper.count ?? 0)
            }
        }
        
        stepper.minusBtn.clickCallback = { [weak self] in
            self?.stepper.count -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self?.inCartCountChanged?(self?.stepper.count ?? 0)
            }
        }
    }
    
    func setupData(data: Card?){
        guard let data = data else { return }
        img.kf.setImage(with: ApiPath.getUrl(path: (data.images.first ?? "") ?? ""))
        name.text = data.name
        stepper.count = data.count ?? 0
        currentPrice.text = "\(data.price) TMT"

        if data.discountPrice > 0 {
            oldPrice.setStrikeThroughText("\(data.discountPrice) TMT")
        } else {
            oldPrice.text = ""
        }
    }
}
