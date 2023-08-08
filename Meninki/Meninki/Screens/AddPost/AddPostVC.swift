//
//  AddPostVC.swift
//  Meninki
//
//  Created by Shirin on 5/1/23.
//

import UIKit
import TLPhotoPicker

class AddPostVC: UIViewController {
    
    var viewModel = AddPostVM()

    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var assetType: MediaType = .image {
        didSet {
            openPicker()
        }
    }
    
    var selectedAssets: [TLPHAsset] = [] {
        didSet {
            if assetType == .image {
                let images = selectedAssets.map({$0.fullResolutionImage})
                mainView.mediaCollectionView.data = images
            } else {
                let img = viewModel.uploadVideo?.image ?? selectedAssets.first?.fullResolutionImage
                mainView.mediaCollectionView.data = img == nil ? [] : [img]
            }
        }
    }
    
    var mainView: AddPostView {
        return view as! AddPostView
    }

    override func loadView() {
        super.loadView()
        view = AddPostView()
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
        
        viewModel.postAdded.bind { [weak self] success in
            if success != true { return }
            var uploadImgs: [UploadImage] = []
            self?.selectedAssets.forEach { asset in
                uploadImgs.append(UploadImage(objectId: self?.viewModel.postId ?? "",
                                              isAvatar: false,
                                              imageType: ImageType.media.rawValue,
                                              width: asset.phAsset?.pixelWidth,
                                              height: asset.phAsset?.pixelHeight,
                                              filename: asset.originalFileName ?? "",
                                              data: asset.fullResolutionImage?.jpegData(compressionQuality: 0.75)))
            }
            
            self?.viewModel.uploadImg = uploadImgs
            
            let tabbar = self?.navigationController?.viewControllers.first as? TabbarVC
            tabbar?.addPostMedia(objectId: self?.viewModel.postId ?? "",
                                 imgs: uploadImgs,
                                 video: self?.viewModel.uploadVideo)
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.mediaAdded.bind { [weak self] success in
            if success != true { return }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.mediaCollectionView.didSelect = { [weak self] ind in
            if self?.assetType == .image { return }
            self?.openTrimmer()
        }
        
        mainView.mediaCollectionView.didRemove = { [weak self] ind in
            self?.selectedAssets.remove(at: ind)
            self?.viewModel.uploadVideo = nil
        }
        
        mainView.mediaCollectionView.addClick = { [weak self] in
            if self?.selectedAssets.isEmpty == true {
                self?.openTypeBS()
            } else {
                self?.openPicker()
            }
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            guard let params = self?.getData() else { return }
            self?.viewModel.addPost(params: params)
        }
    }
    
    func getData() -> AddPost? {
        if selectedAssets.isEmpty && viewModel.uploadVideo == nil {
            PopUpLauncher.showErrorMessage(text: "select_media".localized())
            return nil
        }
        
        guard let desc = mainView.textView.getTextViewValue() else { return nil }
        
        return AddPost(description: desc,
                       productBaseId: viewModel.productId)
    }
    
    func openTypeBS(){
        let vc = PostAssetTypeBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.videoBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            self?.assetType = .video
        }
        
        vc.imageBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            self?.assetType = .image
        }
        
        present(vc, animated: true)
    }
    
    func openPicker(){
        if assetType == .image {
            openImgPicker()
        } else {
            openVideoPicker()
        }
    }
    
    func openImgPicker(){
        let vc = TLPhotosPickerViewController()
        vc.configure.allowedVideo = false
        vc.configure.maxSelectedAssets = 9
        vc.selectedAssets = selectedAssets
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func openVideoPicker(){
        let vc = TLPhotosPickerViewController()
        vc.configure.allowedVideo = true
        vc.configure.allowedPhotograph = false
        vc.configure.singleSelectedMode = true
        vc.configure.allowedVideoRecording = false
        vc.configure.usedCameraButton = false
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func openTrimmer(){
        let vc = VideoTrimmerVC()
        vc.uploadVideo = viewModel.uploadVideo ?? UploadVideo(objectId: "", vertical: true)
        vc.phAsset = selectedAssets.first?.phAsset
        vc.doneClickCallback = { [weak self] uploadFile in
            self?.viewModel.uploadVideo = uploadFile
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddPostVC: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        viewModel.uploadVideo = nil
        selectedAssets = withTLPHAssets

        if assetType == .video {
            guard let asset = withTLPHAssets.first else { return }
            asset.tempCopyMediaFile(completionBlock: { url, _ in
                let isVertical = (asset.phAsset?.pixelWidth ?? 1)/(asset.phAsset?.pixelHeight ?? 1) < 1
                self.viewModel.uploadVideo = UploadVideo(objectId: "",
                                                         filename: asset.originalFileName ?? "",
                                                         image: asset.fullResolutionImage,
                                                         path: url,
                                                         data: try? Data(contentsOf: url),
                                                         vertical: isVertical,
                                                         imgData: asset.fullResolutionImage?.jpegData(compressionQuality: 0.7),
                                                         width: asset.phAsset?.pixelWidth,
                                                         height: asset.phAsset?.pixelHeight)
            })
        }
    }
}
