//
//  AddProductVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import TLPhotoPicker

class AddProductVC: UIViewController {
    
    let viewModel = AddProductVM()
    
    var selectedCats: [Category] = []
    var shop: User?
    
    var options: [[Option]] = []
    var optionTitles: [String] = []
    var optionTypes: [OptionType] = []

    var personalChars: [PersonalCharacteristics] = []
    
    var selectedAssets: [TLPHAsset] = [] {
        didSet {
            let images = selectedAssets.map({$0.fullResolutionImage})
            mainView.mediaCollectionView.data = images
        }
    }
    
    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var mainView: AddProductView {
        return view as! AddProductView
    }
    
    override func loadView() {
        super.loadView()
        view = AddProductView()
        view.backgroundColor = .bg
        view.tag = 12345
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        mainView.addObserver()

        setupBindings()
        setupCallbacks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.category.setTextViewText(selectedCats.map({ $0.getTitle()}).joined(separator: ", "))
        mainView.setupPersonalCharCount(personalChars.count)
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.productAdded.bind { [weak self] success in
            if success == false { return }
            if self?.selectedAssets == nil {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.viewModel.addImage(images: self?.getImages() ?? [])
            }
        }

        viewModel.imgAdded.bind { [weak self] success in
            if success == false { return }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        mainView.category.clickCallback = { [weak self] in
            let vc = FilterCategoryListVC()
            vc.viewModel = CategoriesTabVM()
            vc.viewModel?.selectedCategories = self?.selectedCats ?? []
            vc.viewTag = self?.view.tag ?? 11
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.shop.clickCallback = { [weak self] in
            self?.openShopBS()
        }
        
        mainView.mediaCollectionView.addClick = { [weak self] in
            self?.openPiceker()
        }
        
        mainView.mediaCollectionView.didRemove = { [weak self] ind in
            if self?.selectedAssets.count ?? 0 > ind {
                self?.selectedAssets.remove(at: ind)
            }
        }
        
        mainView.addCharBtn.clickCallback = { [weak self] in
            let vc = AddOptionVC()
            vc.viewModel.productId = self?.viewModel.productId ?? ""
            vc.parentVC = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.optionsBtn.clickCallback = { [weak self] in
            let vc = AddOptionVC()
            vc.toUpdate = true
            vc.options = self?.options ?? []
            vc.optionTypes = self?.optionTypes ?? []
            vc.optionTitles = self?.optionTitles ?? []
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.pricesBtn.clickCallback = { [weak self] in
            let vc = AddPriceVC()
            vc.viewModel.productId = self?.viewModel.productId ?? ""
            vc.viewModel.personalChars = self?.personalChars ?? []
            vc.parentVC = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            guard let data = self?.getProductData() else { return }
            self?.viewModel.addProduct(toAdd: (self?.personalChars ?? []).isEmpty, params: data)
        }
    }
    
    func openShopBS(){
        let vc = ShopsBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.didSelectShop = { [weak self] shop in
            self?.shop = shop
            self?.mainView.shop.textField.text = shop.name
        }
        present(vc, animated: true)
    }
    
    func openPiceker(){
        let vc = TLPhotosPickerViewController()
        vc.delegate = self
        vc.configure.maxSelectedAssets = 9
        vc.configure.allowedVideo = false
        vc.selectedAssets = selectedAssets
        present(vc, animated: true)
    }
    
    func getProductData() -> AddProduct? {
        guard let name = mainView.name.getValue() else { return nil }
        guard let desc = mainView.desc.getTextViewValue() else { return nil }
        guard let _ = mainView.category.getTextViewValue() else { return nil }
        guard let _ = mainView.shop.getValue() else { return nil }
        if personalChars.isEmpty {
            guard let _ = mainView.price.getValue() else { return nil }
        }
        
        return AddProduct(id: viewModel.productId,
                          name: name,
                          description: desc,
                          price: Double(mainView.price.getValue(withChecking: false) ?? "") ?? 0,
                          discountPrice:  Double(mainView.oldPrice.getValue(withChecking: false) ?? "") ?? 0,
                          shopId: shop?.id,
                          categoryIds: selectedCats.map({$0.id}))
    }
    
    func getImages() -> [UploadImage] {
        var img: [UploadImage] = []
        
        selectedAssets.forEach { asset in
            img.append(UploadImage(objectId: viewModel.productId,
                                   isAvatar: false,
                                   imageType: ImageType.media.rawValue,
                                   width: asset.phAsset?.pixelWidth,
                                   height: asset.phAsset?.pixelHeight,
                                   filename: asset.originalFileName,
                                   data: asset.fullResolutionImage?.jpegData(compressionQuality: 0.7)))
        }
        
        return img
    }
}

extension AddProductVC: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        selectedAssets = withTLPHAssets
    }
}
