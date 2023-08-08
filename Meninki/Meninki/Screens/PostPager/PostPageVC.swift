//
//  PostPageVC.swift
//  Meninki
//
//  Created by Shirin on 4/3/23.
//

import UIKit

class PostPageVC: UIViewController {

    var data: Post!
    
    var didAppear: ( ()->() )?
    
    var mainView: PostPageView {
        return view as! PostPageView
    }

    override func loadView() {
        super.loadView()
        view = PostPageView()
        view.backgroundColor = .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.player?.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.player?.play()
//        let p = mainView.player?.isPlaying
//        print("viewDidAppear", mainView.player?.currentItem?.asset)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mainView.player?.pause()
        mainView.player?.seek(to: .zero)
//        let p = mainView.player?.isPlaying
//        print("viewDidDisappear", mainView.player?.currentItem?.asset)
    }
}
