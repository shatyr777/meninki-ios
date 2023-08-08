//
//  MainView.swift
//  Meninki
//
//  Created by Shirin on 4/24/23.
//

import UIKit
import EasyPeasy

class MainView: BaseView {
    
    var tableView: UITableView = {
        let t = UITableView(rowHeight: UITableView.automaticDimension, estimatedRowHeight: 1000)
        t.register(PostListTbCell.self, forCellReuseIdentifier: PostListTbCell.id)
        t.register(BannerTbCell.self, forCellReuseIdentifier: BannerTbCell.id)
        t.register(ShopListTbCell.self, forCellReuseIdentifier: ShopListTbCell.id)
        t.contentInset.top = 24
        t.contentInset.bottom = 80
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(tableView)
        tableView.easy.layout([
            Top().to(safeAreaLayoutGuide, .top),
            Leading(), Trailing(),
            Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
    }
}
