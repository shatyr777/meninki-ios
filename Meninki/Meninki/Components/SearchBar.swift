//
//  SearchBar.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import UIKit

class SearchBar: UIStackView {

    var bg = UIView()
    
    var textField: UITextField = {
        let t = UITextField()
        t.font = .lil_14_b
        t.textColor = .contrast
        t.placeholder = "search".localized()
        return t
    }()

    var searchIcon = IconBtn(icon: UIImage(named: "search"),
                             tintColor: .contrast)
    
    var clearBtn = IconBtn(icon: UIImage(named: "close"),
                                         tintColor: .contrast)
    
    var timer: Timer?

    var beginEditingCallback: ( () -> Void )?
    var clearClickCallback: (() -> Void)?
    var returnClickCallback: (() -> Void)?
    var editingCallback: ((String?) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.delegate = self
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        
        setupView()
        setupCallbacks()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        bg = addBackground(color: .lowContrast,
                           cornerRadius: 10)
        
        addMargins(insets: UIEdgeInsets(hEdges: 16, vEdges: 3))
        
        addArrangedSubviews([textField,
                             searchIcon,
                             clearBtn])
        
        clearBtn.isHidden = true
    }
    
    func setupCallbacks(){
        clearBtn.clickCallback = { [weak self] in
            self?.textField.text = ""
            self?.clearClickCallback?()
        }
        
        searchIcon.clickCallback = { [weak self] in
            self?.returnClickCallback?()
        }
    }
    
    @objc func didChangeText(){
        let t = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        searchIcon.isHidden = !t.isEmpty
        clearBtn.isHidden = t.isEmpty
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(delayedSearch), userInfo: nil, repeats: false)
    }
    
    @objc func delayedSearch(){
        editingCallback?(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

extension SearchBar: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if beginEditingCallback != nil {
            beginEditingCallback?()
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bg.backgroundColor = .white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bg.backgroundColor = .lowContrast
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return click")
        returnClickCallback?()
        return true
    }
}
