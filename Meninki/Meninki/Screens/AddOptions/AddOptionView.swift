//
//  AddOptionView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import EasyPeasy

class AddOptionView: BaseView {
    
    var header = Header(title: "add_options".localized())
    
    var desc = UILabel(font: .lil_14,
                       color: .contrast,
                       text: "add_options_desc".localized())
    
    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    var tableViewFooter = UIStackView(axis: .vertical,
                                      alignment: .fill,
                                      spacing: 10,
                                      backgroundColor: .bg)

    var addOptionBtn = MainBtn(title: "add_options".localized())

    var optionsStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 30)
    
    var doneBtn = MainBtn(title: "done".localized())

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(ImageOptionListTbCell.self, forCellReuseIdentifier: ImageOptionListTbCell.id)
        tableView.register(ValueOptionListTbCell.self, forCellReuseIdentifier: ValueOptionListTbCell.id)
        
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
        
        addSubview(desc)
        desc.easy.layout([
            Top(20).to(header, .bottom), Leading(20), Trailing(20)
        ])
        
        addSubview(doneBtn)
        doneBtn.easy.layout([
            Bottom().to(safeAreaLayoutGuide, .bottom), Leading(20), Trailing(20)
        ])
        
        addSubview(tableView)
        tableView.easy.layout([
            Top(20).to(desc, .bottom), Bottom().to(doneBtn, .top), Leading(20), Trailing(20)
        ])
        
        tableViewFooter.addArrangedSubview(addOptionBtn)
        addOptionBtn.backgroundColor = .contrast
    }
}
