//
//  ListView.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import EasyPeasy

class ListView: BaseView {

    var topInset = UIView()
    
    var header = Header(title: "select_lang".localized())
    
    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(ListTbCell.self, forCellReuseIdentifier: ListTbCell.id)
        
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(topInset)
        topInset.easy.layout([
            Top(), Leading(), Trailing(), Height(DeviceDimensions.topInset)
        ])
        
        addSubview(header)
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing()
        ])
        
        addSubview(tableView)
        tableView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
    }
}
