//
//  AddPriceView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import EasyPeasy

class AddPriceView: BaseView {
    
    var header = Header(title: "add_prices".localized())
    
    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    var doneBtn = MainBtn(title: "done".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(AddPriceTbCell.self, forCellReuseIdentifier: AddPriceTbCell.id)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        addSubview(doneBtn)
        doneBtn.easy.layout([
            Leading(20), Trailing(20), Bottom(20).to(safeAreaLayoutGuide, .bottom)
        ])
        
        addSubview(tableView)
        tableView.easy.layout([
            Top().to(header, .bottom), Bottom().to(doneBtn, .top), Leading(), Trailing()
        ])
    }
}
