//
//  TabbarVC.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import EasyPeasy

class TabbarVC: UITabBarController {

    let tabbar = Tabbar()
    
    var progress = UIProgressView(progressViewStyle: .bar)

    var didUpdateUserData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        tabBar.isHidden = true
        setupVc()
        setupTabbarClicks()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupVc(){
        let home = HomeTabVC()
        let categories = CategoriesTabVC()
        let cart = CartTabVC()
        let profile = UserProfileVC()
        profile.viewModel.id = AccUserDefaults.id
        
        setViewControllers([home, categories, cart, profile], animated: false)
        
        view.addSubview(tabbar)
        tabbar.easy.layout([
            CenterX(), Bottom(20).to(view.safeAreaLayoutGuide, .bottom)
        ])
        
        view.addSubview(progress)
        progress.tintColor = .contrast
        progress.trackTintColor = .lowContrast
        progress.isHidden = true
        progress.easy.layout([
            Leading(), Trailing(), Top().to(view.safeAreaLayoutGuide, .top), Height(4)
        ])
    }
    
    func setupTabbarClicks(){
        tabbar.home.clickCallback = { [self] in
            if selectedIndex == 0 { return }
            tabbar.tabs[selectedIndex].isSelected = false
            selectedIndex = 0
        }
        
        tabbar.category.clickCallback = { [self] in
            if selectedIndex == 1 { return }
            tabbar.tabs[selectedIndex].isSelected = false
            selectedIndex = 1
        }

        tabbar.cart.clickCallback = { [self] in
            if selectedIndex == 2 { return }
            tabbar.tabs[selectedIndex].isSelected = false
            selectedIndex = 2
        }

        tabbar.profile.clickCallback = { [self] in
            if selectedIndex == 3 { return }
            tabbar.tabs[selectedIndex].isSelected = false
            selectedIndex = 3
        }
    }
    
    func updateProfileData(){
        if didUpdateUserData { return }
        if AccUserDefaults.id.isEmpty == false {
            UserRequests.shared.getUserProfile(id: AccUserDefaults.id) { [weak self] profile in
                AccUserDefaults.saveUser(profile)
                AccUserDefaults.shops = profile?.shops?.map({$0.name}) ?? []
                AccUserDefaults.shopIds =  profile?.shops?.map({$0.id}) ?? []
                self?.didUpdateUserData = true
            }
        }
    }
    
    func addPostMedia(objectId: String, imgs: [UploadImage], video: UploadVideo?){
        progress.isHidden = false
        
        if video == nil {
            Network.addImages(images: imgs, objectId: objectId) { [weak self] progress in
                print("progress ", progress)
                self?.progress.progress = progress
            } completionHandler: { [weak self] resp in
                self?.progress.isHidden = true
                self?.progress.progress = 0
                if resp != nil {
                    PopUpLauncher.showSuccessMessage(text: "post_added_sucessfully".localized())
                } else {
                    PopUpLauncher.showErrorMessage(text: "could_not_add_media_of_post".localized())
                }
            }
        } else {
            guard let uploadVideo = video else { return }
            AddRequests.shared.addVideo(video: uploadVideo, objectId: objectId) { [weak self] progress in
                print("progress ", progress)
                self?.progress.progress = progress
            } completionHandler: { [weak self] resp in
                self?.progress.isHidden = true
                self?.progress.progress = 0
                if resp != nil {
                    PopUpLauncher.showSuccessMessage(text: "post_added_sucessfully".localized())
                } else {
                    PopUpLauncher.showErrorMessage(text: "could_not_add_media_of_post".localized())
                }
            }
        }
    }
}

extension TabbarVC: TabBarDelegate {
    func didScroll(toShow: Bool) {
        print("toShow: ", toShow)
    }
}
