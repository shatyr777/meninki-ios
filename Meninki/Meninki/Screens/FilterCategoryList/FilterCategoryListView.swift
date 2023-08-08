//
//  FilterCategoryListView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import EasyPeasy

class FilterCategoryListView: BaseView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    
    var header = Header(title: "categories".localized(), trailingIcon: UIImage(systemName: "checkmark"))
    
    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        tableView.register(FilterCategoryTbCell.self, forCellReuseIdentifier: FilterCategoryTbCell.id)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 80, right: 0)

        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([header, tableView])
    }
}
