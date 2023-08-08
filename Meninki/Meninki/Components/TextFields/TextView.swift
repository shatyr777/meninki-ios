//
//  TextView.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit
import EasyPeasy

class TextView: UIView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 6)
    
    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0)

    var textField: UITextView = {
        let t = UITextView()
        t.layer.borderColor = UIColor.lowContrast.cgColor
        t.layer.cornerRadius = 10
        t.layer.borderWidth = 1
        t.backgroundColor = .white
        t.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        t.isScrollEnabled = false
        t.textColor = .neutralDark
        t.font = .lil_14
        return t
    }()
    
    var placeholder = ""

    init(title: String,
         placeholder: String){
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.title.text = title
        textField.text = placeholder
        textField.delegate = self
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([title,
                                          textField])
    }
    
    func getValue() -> String? {
        return textField.textColor == .neutralDark ? nil : textField.text
    }
}

extension TextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textField.textColor == .neutralDark && textField.text == placeholder {
            textField.text = nil
            textField.textColor = .contrast
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textField.text.isEmpty {
            textField.text = placeholder
            textField.textColor = .neutralDark
        }
    }
}
