//
//  EnterTextView.swift
//  Meninki
//
//  Created by NyanDeveloper on 16.01.2023.
//

import UIKit
import EasyPeasy

class EnterTextView: UIView {
    
    var keyboardIsShown = false
    
    var bg = UIView()

    var textfieldWrapper = UIStackView(axis: .vertical,
                                       alignment: .fill,
                                       spacing: 20,
                                       edgeInsets: UIEdgeInsets(hEdges: 20))
    
    var textfield = TextField(title: "",
                              value: "",
                              placeholder: "add_text".localized())
    
    var doneBtn = MainBtn(title: "done".localized())
    
    var dismissClickCallback: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bg.isUserInteractionEnabled = true
        bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        
        setupView()
        addObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(bg)
        bg.easy.layout(Edges())
        
        bg.addSubview(textfieldWrapper)
        textfieldWrapper.easy.layout([
            Height(160), Leading(40), Trailing(40), CenterY()
        ])
        
        textfieldWrapper.addArrangedSubviews([UIView(),
                                              textfield,
                                              doneBtn,
                                              UIView()])
        
        let bg = textfieldWrapper.addBackground(color: .bg,
                                                cornerRadius: 10)
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardRectangle = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardRectangle.size.height
        
        keyboardIsShown = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.bg.easy.layout(
                    Bottom(keyboardHeight)
                )
                self.layoutIfNeeded()
            }
        }

    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        keyboardIsShown = false

        UIView.animate(withDuration: 0.001) { [weak self] in
            guard let self = self else { return }
            self.bg.easy.layout(
                Bottom().to(self.safeAreaLayoutGuide, .bottom)
            )
            self.layoutIfNeeded()
        }
    }
    
    @objc func click() {
        if keyboardIsShown {
            endEditing(true)
            return
        }
        
        dismissClickCallback?()
    }
}
