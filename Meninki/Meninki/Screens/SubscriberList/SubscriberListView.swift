//
//  SubscriberListView.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class SubscriberListView: BaseView {
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    
    var header = Header(title: "subscribe_list")
    
    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        tableView.register(SubscribeTbCell.self, forCellReuseIdentifier: SubscribeTbCell.id)
        tableView.contentInset.top = 14
        
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([header, tableView])
    }
}
