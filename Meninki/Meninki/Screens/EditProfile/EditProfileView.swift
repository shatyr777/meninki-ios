//
//  EditProfileView.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit
import EasyPeasy

class EditProfileView: BaseView {
    
    var header = Header(title: "edit_profile".localized())

    var profileImgWrapper = UIView()
    
    var profileImg = ProfileImg(size: 120)
    
    var scrollView = ScrollView(spacing: 10,
                                edgeInsets: UIEdgeInsets(edges: 10),
                                keyboardDismissMode: .interactive)
    
    var username = TextField(title: "username".localized(),
                             value: AccUserDefaults.username,
                             placeholder: "username".localized())

    var name = TextField(title: "name".localized(),
                         value: AccUserDefaults.name,
                         placeholder: "name".localized())
        
    var phone = TextField(title: "phone".localized(),
                          value: AccUserDefaults.phone ?? "",
                          placeholder: "phone".localized())
    
    var email = TextField(title: "email".localized(),
                          value: AccUserDefaults.email ?? "",
                          placeholder: "email".localized())
    
    var doneBtn = MainBtn(title: "done".localized())

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            Bottom(20).to(safeAreaLayoutGuide, .bottom), Leading(20), Trailing(20)
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Bottom().to(doneBtn, .top),
            Leading(20), Trailing(20)
        ])

        profileImgWrapper.addSubview(profileImg)
        profileImg.easy.layout([
            Top(), Bottom(), CenterX()
        ])
        
        scrollView.contentStack.addArrangedSubviews([profileImgWrapper,
                                                     username,
                                                     name,
                                                     phone,
                                                     email])
        
        phone.isHidden = (AccUserDefaults.phone ?? "").isEmpty
        email.isHidden = (AccUserDefaults.email ?? "").isEmpty
        profileImg.kf.setImage(with: ApiPath.getUrl(path: AccUserDefaults.avatar ?? ""))
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
                self.doneBtn.easy.layout( Bottom(keyboardHeight + 20 ))
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.0001) { [weak self] in
            guard let self = self else { return }
            self.doneBtn.easy.layout( Bottom().to(self.safeAreaLayoutGuide, .bottom))
            self.layoutIfNeeded()
        }
    }
}
