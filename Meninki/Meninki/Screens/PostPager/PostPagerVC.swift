//
//  PostPagerVC.swift
//  Meninki
//
//  Created by Shirin on 4/3/23.
//

import UIKit
import EasyPeasy

class PostPagerVC: UIPageViewController {
    
    weak var viewModel: FeedVM!
    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var VCs: [UIViewController] = [UIViewController]()
    var current: Int = 0 {
        didSet {
            
        }
    }

    required init(viewModel: FeedVM, current: Int) {
        self.viewModel = viewModel
        self.current = current

        super.init(transitionStyle: .scroll,
                   navigationOrientation: .vertical,
                   options: nil)

        view.backgroundColor = .black
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackBtn()

        setupVCs()
        setupBindings()
    }
    
    func addBackBtn(){
        let backBtn = IconBtn(icon: UIImage(named: "back")?.withRenderingMode(.alwaysTemplate))

        view.addSubview(backBtn)
        backBtn.imageView?.tintColor = .white
        backBtn.easy.layout([
            Top(10).to(view.safeAreaLayoutGuide, .top),
            Leading(10)
        ])
        
        backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupVCs(){
        VCs = []
        for i in 0 ..< viewModel.data.value.count {
            let vc = viewControllerAtIndex(index: i)
            VCs.append(vc ?? UIViewController())
        }
        
        setViewControllers([VCs[current]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }

    func viewControllerAtIndex(index: Int) -> PostPageVC? {
        if viewModel.data.value.count == 0
            || index >= viewModel.data.value.count
            || index < 0 {
            return nil
        }

        let page = viewModel.data.value[index]
        let vc = PostPageVC()
        vc.data = page
        vc.mainView.setupData(data: page)
        
        vc.mainView.likeBtn.clickCallback = { [weak self] in
            let isLiked = page.rating?.userRating?.keys.contains(where: { $0 == AccUserDefaults.id })
            self?.changeLike(id: page.id, isLiked: isLiked)
            
            if isLiked == true {
                vc.mainView.likeBtn.icon.image = UIImage(named: "heart")
                vc.mainView.likeBtn.count.text = "\((page.rating?.total ?? 1)-1 )"
            } else {
                vc.mainView.likeBtn.icon.image = UIImage(named: "heart-filled")
                vc.mainView.likeBtn.count.text = "\((page.rating?.total ?? 0)+1 )"
            }
        }
        
        vc.mainView.subscribeBtn.subscribeClickCallback = { [weak self] in
            let params = ChangeLike(id: page.user?.id ?? "", isSubscribe: true)
            self?.viewModel?.changeSubscription(params: params)
        }
        
        vc.mainView.subscribeBtn.unsubscribeClickCallback = { [weak self] in
            let params = ChangeLike(id: page.user?.id ?? "", isSubscribe: false)
            self?.viewModel?.changeSubscription(params: params)
        }
        
        vc.mainView.footer.clickCallback = { [weak self] in
            self?.goToProduct(productId: page.productId)
        }
        
        vc.mainView.footer.moreBtn.clickCallback = { [weak self] in
            self?.openMoreBS(post: page)
        }
        return vc
    }
    
    func setupBindings(){
//        viewModel.data.bind { [weak self] data in
//            guard let s = self else { return }
//            print("PAGE ",  s.viewModel.params.pageNumber)
//            if s.viewModel.params.pageNumber == 1 {
//                s.setupVCs()
//            } else {
//                for i in s.VCs.count-1 ..< data.count {
//                    print(i)
//                    let vc = s.viewControllerAtIndex(index: i)
//                    s.VCs.append(vc ?? UIViewController())
//                }
//            }
//        }
    }
    
    func openMoreBS(post: Post?){
        let vc = FeedMoreBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.delegate = self
        vc.data = post
        present(vc, animated: true)
    }
}

extension PostPagerVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCs.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1
        guard VCs.count > previousIndex else { return nil }
        
        guard previousIndex >= 0 else {
            viewModel.getData(forPage: 1)
            return nil
        }
        
        return VCs[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCs.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1
        guard VCs.count > nextIndex else {
            viewModel.getData(forPage: viewModel.params.pageNumber + 1)
            return nil
        }
        return VCs[nextIndex]
    }
}

extension PostPagerVC: FeedBSDelegate {
    func changeLike(id: String?, isLiked: Bool?) {
        guard let id = id else { return }
        if isLiked == true {
            dislike(id: id)
        } else {
            like(id: id)
        }
    }

    func like(id: String?) {
        guard let id = id else { return }
        let params = ChangeLike(id: id, isIncrease: true)
        viewModel.changeRating(params: params)
    }
    
    func dislike(id: String?) {
        guard let id = id else { return }
        let params = ChangeLike(id: id, isIncrease: nil)
        viewModel.changeRating(params: params)
    }
    
    func copyPath(path: String?) {
        if (path ?? "").isEmpty == true {
            showToast(message: "copy_failed".localized())
        } else {
            UIPasteboard.general.string = path ?? ""
            showToast(message: "copied".localized())
        }
    }
    
    func goToProduct(productId: String?) {
        let vc = ProductVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToUserProfile(userId: String?) {
        guard let id = userId else { return }
        let vc = UserProfileVC()
        vc.viewModel.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToShopProfile(shopId: String?) {
        guard let id = shopId else { return }
        let vc = ShopProfileVC()
        vc.viewModel.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func complain(id: String?) {
        print("OPEN COMPLAIN")
    }
}
