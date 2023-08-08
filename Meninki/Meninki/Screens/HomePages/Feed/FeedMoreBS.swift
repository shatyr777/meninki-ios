//
//  FeedMoreBS.swift
//  Meninki
//
//  Created by Shirin on 4/22/23.
//

import UIKit

class FeedMoreBS: UIViewController {

    weak var delegate: FeedBSDelegate?
    
    var data: Post?
    
    var likeBtn = BottomSheetBtn(title: "like".localized(), icon: UIImage(named: "heart"))
    
    var dislikeBtn = BottomSheetBtn(title: "remove_like".localized(), icon: UIImage(named: "heart-filled"))

    var share = BottomSheetBtn(title: "share".localized(), icon: UIImage(named: "link"))

    var goToProduct = BottomSheetBtn(title: "go_to_product".localized(), icon: UIImage(named: "box"))

    var goToUserProfile = BottomSheetBtn(title: "go_to_user_profile".localized(), icon: nil)
    
    var complain = BottomSheetBtn(title: "complain".localized(), icon: nil)

    var mainView: BottomSheetView {
        return view as! BottomSheetView
    }

    override func loadView() {
        super.loadView()
        view = BottomSheetView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCallbacks()
    }
    
    func setupView(){
        mainView.title.text = ""
        mainView.desc.text = ""
        
        let isLiked = data?.rating?.userRating?[AccUserDefaults.id] == true
        mainView.btnStack.addArrangedSubviews([isLiked ? dislikeBtn : likeBtn,
//                                               share,
                                               goToProduct,
                                               goToUserProfile,
                                               complain])
    }
    
    func setupCallbacks(){
        likeBtn.clickCallback = { [weak self] in
            self?.delegate?.like(id: self?.data?.id)
            self?.dismiss(animated: true)
        }
        
        dislikeBtn.clickCallback = { [weak self] in
            self?.delegate?.dislike(id: self?.data?.id)
            self?.dismiss(animated: true)
        }
        
        share.clickCallback = { [weak self] in
            self?.delegate?.copyPath(path: "path ")
            self?.dismiss(animated: true)
        }

        goToProduct.clickCallback = { [weak self] in
            self?.delegate?.goToProduct(productId: self?.data?.productId)
            self?.dismiss(animated: true)
        }

        goToUserProfile.clickCallback = { [weak self] in
            self?.delegate?.goToUserProfile(userId: self?.data?.user?.id)
            self?.dismiss(animated: true)
        }

        complain.clickCallback = { [weak self] in
            self?.delegate?.complain(id: self?.data?.id)
            self?.dismiss(animated: true)
        }
    }
}
