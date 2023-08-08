//
//  RegisterView.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import EasyPeasy

class RegisterView: BaseView {

    var topInset = UIView()
    
    var header = Header(title: "tell_about_yourself".localized())
    
    var scrollView = ScrollView(spacing: 20,
                                edgeInsets: UIEdgeInsets(top: 20, left: 40, bottom: 40, right: 40),
                                keyboardDismissMode: .interactive)
    
    var desc = UILabel(font: .lil_14,
                       color: .contrast,
                       alignment: .left,
                       numOfLines: 0,
                       text: "can_add_edit_later".localized())
    
    var nameTextField = TextField(title: "enter_name".localized(),
                                  value: AccUserDefaults.name,
                                  placeholder: "name".localized())
    
    var usernameTextField = TextField(title: "enter_username".localized(),
                                      value: "",
                                      placeholder: "username".localized(),
                                      leadingText: "@")
    
    var doneBtn = MainBtn(title: "done".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(topInset)
        topInset.backgroundColor = .lowContrast
        topInset.easy.layout([
            Top(), Leading(), Trailing(), Height(DeviceDimensions.topInset)
        ])
        
        addSubview(header)
        header.backBtn.isHidden = true
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing()
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
        
        scrollView.contentStack.easy.layout(
            Height(DeviceDimensions.safeAreaHeight - 40)
        )
    }
    
    func setupContent(){
        scrollView.contentStack.addArrangedSubviews([desc,
                                                     nameTextField,
                                                     usernameTextField,
                                                     UIView(),
                                                     doneBtn])
        
        scrollView.contentStack.setCustomSpacing(50, after: desc)
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
                self.scrollView.contentInset.bottom = keyboardHeight+20
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.0001) { [weak self] in
            guard let self = self else { return }
            self.scrollView.contentInset.bottom = 0
            self.layoutIfNeeded()
        }
    }
}
