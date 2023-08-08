//
//  CartTabView.swift
//  Meninki
//
//  Created by Shirin on 4/25/23.
//

import UIKit
import EasyPeasy

class CartTabView: BaseView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    var header = CartHeader()
    
    var tableView = UITableView(style: .grouped,
                                rowHeight: UITableView.automaticDimension)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        tableView.register(CartTbHeader.self, forHeaderFooterViewReuseIdentifier: CartTbHeader.id)
        tableView.register(CartTbCell.self, forCellReuseIdentifier: CartTbCell.id)
        tableView.contentInset.bottom = 70
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([header,
                                          tableView])
    }
}
