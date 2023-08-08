//
//  SelectAddress.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class SelectAddressView: UIView {

    lazy var header = Header(title: "select_address".localized())
    
    lazy var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    lazy var doneBtn = MainBtn(title: "done".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(AddressTbCell.self, forCellReuseIdentifier: AddressTbCell.id)
        tableView.register(AddAddressFooter.self, forCellReuseIdentifier: AddAddressFooter.id)

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
            Leading(), Trailing(),
            Top().to(header, .bottom), Bottom().to(doneBtn, .top)
        ])
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardRectangle = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardRectangle.size.height
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.tableView.easy.layout( Bottom(keyboardHeight))
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.0001) { [weak self] in
            guard let self = self else { return }
            self.tableView.easy.layout( Bottom().to(self.doneBtn, .top))
            self.layoutIfNeeded()
        }
    }
}
