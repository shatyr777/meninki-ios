//
//  EditProfileVC.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit
import TLPhotoPicker

class EditProfileVC: UIViewController {

    let viewModel = EditProfileVM()
    
    var mainView: EditProfileView {
        return view as! EditProfileView
    }
    
    override func loadView() {
        super.loadView()
        view = EditProfileView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addObserver()
        hideKeyboardWhenTappedAround()
        
        setupBindings()
        setupCallbacks()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.success.bind { [weak self] success in
            if success {
                UserProfileVC.update = true
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.profileImg.clickCallback = { [weak self] in
            self?.openPiceker()
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            guard let params = self?.getData() else{ return }
            self?.viewModel.updateProfile(params: params)
        }
    }
    
    func getData() -> UpdateUser? {
        guard let username = mainView.username.isValidUsername() else { return nil }
        return UpdateUser(userName: username,
                          firstName: mainView.name.getValue(withChecking: false) ?? "")
    }
    
    func openPiceker(){
        let vc = TLPhotosPickerViewController()
        vc.delegate = self
        vc.configure.maxSelectedAssets = 1
        vc.configure.allowedVideo = false
        present(vc, animated: true)
    }
}

extension EditProfileVC: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        guard let first = withTLPHAssets.first else { return }
        
        viewModel.uploadImg = UploadImage(objectId: AccUserDefaults.id,
                                          isAvatar: true,
                                          imageType: ImageType.user.rawValue,
                                          width: first.phAsset?.pixelWidth,
                                          height: first.phAsset?.pixelHeight,
                                          filename: first.originalFileName ?? "",
                                          data: first.fullResolutionImage?.jpegData(compressionQuality: 0.75))
        
        mainView.profileImg.image = first.fullResolutionImage
    }
}
