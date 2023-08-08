//
//  SearchView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 17.05.2023.
//

import UIKit
import EasyPeasy

class SearchView: UIView {

    var header = Header(title: "")
        
    var scrollView = ScrollView(spacing: 10,
                                edgeInsets: UIEdgeInsets(hEdges: 16))
    
    let search = SearchBar()
    
    let tableView = UITableView(rowHeight: UITableView.automaticDimension)

    let doneBtn = MainBtn(title: "search".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(SearchTbCell.self, forCellReuseIdentifier: SearchTbCell.id)
        tableView.contentInset.top = 20
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        header.addArrangedSubview(search)
        addSubview(header)
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
                
        addSubview(doneBtn)
        doneBtn.easy.layout([
            Bottom(20).to(safeAreaLayoutGuide, .bottom), Leading(20), Trailing(20)
        ])
        
        addSubview(tableView)
        tableView.easy.layout([
            Top().to(search, .bottom), Leading(), Trailing(), Bottom().to(doneBtn, .top)
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
                self.doneBtn.easy.layout( Bottom(keyboardHeight+20))
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.0001) { [weak self] in
            guard let self = self else { return }
            self.doneBtn.easy.layout( Bottom(20).to(self.safeAreaLayoutGuide, .bottom))
            self.layoutIfNeeded()
        }
    }
}
