//
//  CategoryListView.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit
import EasyPeasy

class CategoryListView: UIView {
    
    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(CategoryTbCell.self, forCellReuseIdentifier: CategoryTbCell.id)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 80, right: 0)
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
