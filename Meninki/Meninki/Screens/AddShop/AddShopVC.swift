//
//  AddShopVC.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit
import TLPhotoPicker

class AddShopVC: UIViewController {

    let viewModel = AddShopVM()
    var selectedCats: [Category] = []

    var mainView: AddShopView {
        return view as! AddShopView
    }
    
    override func loadView() {
        super.loadView()
        view = AddShopView()
        view.backgroundColor = .bg
        view.tag = 1234
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        mainView.addObserver()

        setupBindings()
        setupCallbacks()
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.category.setTextViewText(selectedCats.map({ $0.getTitle()}).joined(separator: ", "))
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.shopAdded.bind { [weak self] success in
            if success == false { return }
            if self?.viewModel.uploadImg == nil {
                UserProfileVC.update = true
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.viewModel.addImage()
            }
        }

        viewModel.imgAdded.bind { [weak self] success in
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
            self?.viewModel.addShop(params: params)
        }
        
        mainView.category.clickCallback = { [weak self] in
            let vc = FilterCategoryListVC()
            vc.viewModel = CategoriesTabVM()
            vc.viewModel?.selectedCategories = self?.selectedCats ?? []
            vc.viewTag = self?.view.tag ?? 11
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupData(){
        guard let shop = viewModel.shop else { return }
        selectedCats = shop.categories ?? []
        mainView.profileImg.kf.setImage(with: ApiPath.getUrl(path: shop.imagePath ?? ""))
        mainView.name.textField.text = shop.name
        mainView.desc.setTextViewText(shop.description ?? "")
    }
    
    func getData() -> AddShop? {
        guard let name = mainView.name.getValue() else { return nil }
        guard let _ = mainView.category.getTextViewValue() else { return nil }
        return AddShop(id: viewModel.shop?.id,
                       name: name,
                       descriptionTm: mainView.desc.getTextViewValue(withChecking: false) ?? "",
                       email: "",
                       phoneNumber: "",
                       categories: selectedCats.map({$0.id}))
    }
    
    func openPiceker(){
        let vc = TLPhotosPickerViewController()
        vc.delegate = self
        vc.configure.maxSelectedAssets = 1
        vc.configure.allowedVideo = false
        present(vc, animated: true)
    }
}

extension AddShopVC: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        guard let first = withTLPHAssets.first else { return }
        
        viewModel.uploadImg = UploadImage(objectId: AccUserDefaults.id,
                                          isAvatar: true,
                                          imageType: ImageType.shop.rawValue,
                                          width: first.phAsset?.pixelWidth,
                                          height: first.phAsset?.pixelHeight,
                                          filename: first.originalFileName ?? "",
                                          data: first.fullResolutionImage?.jpegData(compressionQuality: 0.75))
        
        mainView.profileImg.image = first.fullResolutionImage
    }
}
