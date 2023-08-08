//
//  OrderTbCell.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit
import EasyPeasy

class OrderTbCell: UITableViewCell {

    static let id = "OrderTbCell"
    
    var bg = UIView()
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(edges: 14))
    
    var productInfoStack = UIStackView(axis: .horizontal,
                                       alignment: .fill,
                                       spacing: 10)
    
    var productImg = UIImageView(contentMode: .scaleAspectFill,
                                 cornerRadius: 10)
    
    var productTitleStack = UIStackView(axis: .vertical,
                                        alignment: .fill,
                                        spacing: 10)
    
    var productTitle = UILabel(font: .sb_16,
                               color: .contrast)
    
    var quantity = UILabel(font: .lil_14,
                           color: .contrast)

    var price = UILabel(font: .sb_16,
                        color: .contrast)
    
    var productPriceStack = UIStackView(axis: .horizontal,
                                        alignment: .fill,
                                        spacing: 8)

    var oldPrice = UILabel(font: .lil_14,
                           color: .contrast)
    
    var discount = UILabel(font: .lil_12,
                           color: .lukas)
        
    var orderedBy = OrderInfoBlock(title: "ordered_by".localized(),
                                   axis: .horizontal)
    
    var phoneNumber = OrderInfoBlock(title: "phone".localized(),
                                     axis: .horizontal)
    
    var address = OrderInfoBlock(title: "address".localized(),
                                 axis: .vertical)
    
    var deliverBtn = MainBtn(title: "mark_as_delivered".localized())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        deliverBtn.setTitle("mark_as_delivered".localized(), for: .normal)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Top(10), Leading(14), Trailing(14), Bottom()
        ])
        
        bg = contentStack.addBackground(color: .white,
                                        cornerRadius: 10,
                                        borderWidth: 1,
                                        borderColor: .lowContrast)
        

        productImg.easy.layout(Size(DeviceDimensions.width/3.5))
        contentStack.addArrangedSubviews([productInfoStack,
                                          orderedBy,
                                          phoneNumber,
                                          address,
                                          deliverBtn])
        
        productInfoStack.addArrangedSubviews([productImg, productTitleStack])
        productTitleStack.addArrangedSubviews([productTitle, quantity, UIView(), price, productPriceStack])
        productPriceStack.addArrangedSubviews([discount, oldPrice, UIView()])
    }
    
    func setupData(data: ShopOrder?){
        guard let data = data else { return }
        guard let product = data.products.first?.product else { return }
        productImg.kf.setImage(with: ApiPath.getUrl(path: (product.images.first ?? "") ?? ""))
        productTitle.text = product.name
        price.text = "\(product.price) TMT"
        
        if product.discountPrice > 0 {
            let percent = Int(100*product.price/product.discountPrice)
            oldPrice.setStrikeThroughText("\(product.discountPrice) TMT")
            discount.text = "\(100 - percent)%"
        } else {
            oldPrice.text = ""
            discount.text = ""
        }
        
        quantity.text = "X\(data.products.count)"
        orderedBy.setupValue(data: "\(data.firstName) \(data.lastName)")
        phoneNumber.setupValue(data: data.phoneNumber)
        address.setupValue(data: data.adress)
        deliverBtn.isHidden = data.orderStatus == OrderStatus.delivered.rawValue
    }
}
