//
//  AddAddressFooter.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class AddAddressFooter: UITableViewCell {

    static let id = "AddAddressFooter"
    
    var isClosed = true {
        didSet {
            if isClosed == true {
                setupClosedState()
            } else {
                setupOpenedState()
            }
        }
    }
    
    let contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10)
    
    let addBtn = BottomSheetBtn(title: "add_new_address".localized(), icon: UIImage(named: "plus"))
        
    var textField = TextField(title: "address".localized(),
                              value: "",
                              placeholder: "address".localized())
    
    var btnWrapper = UIStackView(axis: .horizontal,
                                 alignment: .fill,
                                 spacing: 0)
    
    var addSmallBtn = MainBtn(title: "add".localized())
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupView()
        setupClosedState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Top(10), Leading(20), Trailing(20), Bottom(10)
        ])
        
        addBtn.spacer.removeFromSuperview()
        btnWrapper.distribution = .fillEqually
        btnWrapper.addArrangedSubviews([UIView(),
                                       addSmallBtn])
    }

    func setupOpenedState(){
        addBtn.title.text = "close".localized()
        addBtn.icon.image = UIImage(named: "minus")?.withRenderingMode(.alwaysTemplate)
        
        contentStack.removeSubviews()
        contentStack.addArrangedSubviews([addBtn,
                                          textField,
                                          btnWrapper])
    }
    
    func setupClosedState(){
        addBtn.title.text = "add".localized()
        addBtn.icon.image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        
        contentStack.removeSubviews()
        contentStack.addArrangedSubview(addBtn)
    }
    
    func addAddress() -> Bool {
        if textField.textField.text?.isEmpty == true {
            textField.error()
            return false
        }
        
        AccUserDefaults.addresses.append(textField.getValue() ?? "")
        textField.textField.text = ""
        return true
    }
}
