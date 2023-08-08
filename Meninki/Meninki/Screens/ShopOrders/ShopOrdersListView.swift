//
//  ShopOrdersListView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit
import EasyPeasy

class ShopOrdersListView: BaseView {

    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(OrderTbCell.self, forCellReuseIdentifier: OrderTbCell.id)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(tableView)
        tableView.easy.layout(Edges())
    }
}
