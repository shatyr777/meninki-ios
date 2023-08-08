//
//  TextField.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import EasyPeasy

class TextField: UIStackView {

    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0)
    
    var fieldWrapper = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(hEdges: 20))
    
    var leadingText = UILabel(font: .lil_14_b,
                              color: .neutralDark,
                              alignment: .center,
                              numOfLines: 1)
    
    var leadingSeperator: UIView = {
        let v = UIView()
        let line = UIView()
        line.backgroundColor = .neutralDark
        line.easy.layout(Width(1), Height(18))
        v.addSubview(line)
        line.easy.layout([
            CenterY(), Leading(), Trailing()
        ])
        return v
    }()
    
    var textField: UITextField = {
        let t = UITextField()
        t.textColor = .contrast
        t.font = .lil_14_b
        return t
    }()
    
    var textView: UITextView = {
        let t = UITextView()
        t.textContainerInset = UIEdgeInsets(vEdges: 14)
        t.isScrollEnabled = false
        t.textColor = .neutralDark
        t.font = .lil_14_b
        t.backgroundColor = .clear
        return t
    }()
    
    var trailingIcon = UIImageView(contentMode: .scaleAspectFill,
                                   cornerRadius: 0,
                                   image: nil,
                                   backgroundColor: .clear)
    
    var errorText = UILabel(font: .lil_12,
                            color: .lukas,
                            alignment: .left,
                            numOfLines: 1)

    var bgView = UIView()
    
    var placeholder = ""
    var errorDesc = ""
    var isRequired = true
    
    var clickCallback: ( ()->() )?
    var didEndEditing: ( (String)->() )?
    
    init(title: String,
         value: String,
         placeholder: String,
         keyboardType: UIKeyboardType = .default,
         leadingText: String? = nil,
         trailingIcon: UIImage? = nil,
         isRequied: Bool = true,
         isSecured: Bool = false,
         errorHint: String = "should_be_filled".localized()){
        super.init(frame: .zero)
        
        setupView()
        self.placeholder = placeholder
        self.isRequired = isRequied
        self.title.text = title
        self.leadingText.text = leadingText
        textField.text = value.trimmingCharacters(in: .whitespacesAndNewlines)
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecured
        textField.delegate = self
        errorDesc = errorHint
        if leadingText == nil {
            self.leadingText.removeFromSuperview()
            self.leadingSeperator.removeFromSuperview()
        }
        
        if trailingIcon == nil && !isSecured {
            self.trailingIcon.removeFromSuperview()
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        self.axis = .vertical
        self.spacing = 6

        addArrangedSubviews([title,
                             fieldWrapper,
                             errorText])
        
        setupField()
    }
    
    func setupField(){
        fieldWrapper.addArrangedSubviews([leadingText,
                                          leadingSeperator,
                                          textField,
                                          trailingIcon])
        
        bgView = fieldWrapper.addBackground(color: .lowContrast,
                                            cornerRadius: 10,
                                            borderWidth: 1,
                                            borderColor: .clear)
        
        fieldWrapper.easy.layout(Height(>=46))
        leadingText.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func makeTextView(){
        fieldWrapper.insertArrangedSubview(textView, at: 1)
        textView.text = placeholder
        textView.delegate = self
        textField.removeFromSuperview()
    }
    
    func inactive(){
        bgView.backgroundColor = .lowContrast
        bgView.layer.borderColor = UIColor.clear.cgColor
        errorText.text = ""
    }
    
    func active(){
        bgView.backgroundColor = .white
        bgView.layer.borderColor = UIColor.clear.cgColor
        errorText.text = ""
    }
    
    func error(_ text: String? = nil){
        bgView.backgroundColor = .lowContrast
        bgView.layer.borderColor = UIColor.lukas.cgColor
        errorText.text = text ?? errorDesc
    }
    
    func setTextViewText(_ text: String){
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = .neutralDark
        } else {
            textView.text = text
            textView.textColor = .contrast
        }
    }
    

    func getValue(withChecking: Bool = true) -> String? {
        let result = textField.text
        
        if withChecking && (result?.isEmpty == true || result == nil) {
            error()
        } else {
            inactive()
        }
        
        return result?.isEmpty == true ? nil : result
    }
    
    func getTextViewValue(withChecking: Bool = true) -> String? {
        let result = textView.textColor == .neutralDark ? "" : textView.text
        
        if withChecking && (result?.isEmpty == true || result == nil) {
            error()
        } else {
            inactive()
        }
        
        return result?.isEmpty == true ? nil : result
    }
    
    func isValidPhone() -> String? {
        guard let phone = getValue() else { return nil }
        if phone.isEmpty { return nil }
        
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        if phoneTest.evaluate(with: phone) {
            return phone
        } else {
            error("invalid_phone".localized())
            return nil
        }
    }
    
    func isValidUsername() -> String? {
        guard let username = getValue() else { return nil }
        if username.isEmpty { return nil }
        
        let regex = "\\A\\w{6,30}\\z"
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if usernameTest.evaluate(with: username) {
            return username
        } else {
            error("invalid_username".localized())
            return nil
        }
    }
    
    @objc func click(){
        clickCallback?()
    }
}

extension TextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        active()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inactive()
        didEndEditing?(textField.text ?? "")
    }
}

extension TextField: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textView.textColor == .neutralDark && self.textView.text == placeholder {
            self.textView.text = nil
            self.textView.textColor = .contrast
        }
        
        active()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text.isEmpty {
            self.textView.text = placeholder
            self.textView.textColor = .neutralDark
        }
        
        inactive()
    }
}
