//
//  PhoneView.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import EasyPeasy

class PhoneView: BaseView {

    var header = UIStackView(axis: .horizontal,
                             alignment: .fill,
                             spacing: 20,
                             edgeInsets: UIEdgeInsets(hEdges: 40, vEdges: 10))
    
    var title = UILabel(font: .sb_16,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0,
                        text: "auth".localized())
    
    var langBtn = IconBtn(icon: UIImage(named: "globe"))

    var scrollView = ScrollView(spacing: 20,
                                edgeInsets: UIEdgeInsets(top: 50, left: 40, bottom: 40, right: 40),
                                keyboardDismissMode: .interactive)
    
    var phoneTextField = TextField(title: "enter_phone".localized(),
                                   value: "",
                                   placeholder: "phone".localized(),
                                   keyboardType: .phonePad,
                                   leadingText: "+993")
    
    var doneBtn = MainBtn(title: "done".localized(),
                          isActive: true)
    
    var signInWithApple = TextIconBtn(title: "sign_in_with_apple".localized(),
                                      icon: UIImage(named: "apple"))
    
    var signInWithGoogle = TextIconBtn(title: "sign_in_with_google".localized(),
                                      icon: UIImage(named: "google"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
        setupContent()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing(),
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(),
            Bottom().to(safeAreaLayoutGuide, .bottom),
        ])
        
        scrollView.contentStack.easy.layout([
            Height(DeviceDimensions.safeAreaHeight-64)
        ])
    }
    
    func setupHeader(){
        header.addArrangedSubviews([title,
                                    langBtn])
    }
    
    func setupContent(){
        scrollView.contentStack.addArrangedSubviews([phoneTextField,
                                                     doneBtn,
                                                     UIView(),
                                                     signInWithApple,
                                                     signInWithGoogle])
        
        scrollView.contentStack.setCustomSpacing(14, after: signInWithApple)
    }
    
    func setupText(){
        title.text = "auth".localized()
        phoneTextField.title.text = "enter_phone".localized()
        phoneTextField.textField.placeholder = "phone".localized()
        signInWithApple.title.text = "sign_in_with_apple".localized()
        signInWithGoogle.title.text = "sign_in_with_google".localized()
        doneBtn.setTitle("done".localized(), for: .normal)
    }
}
