//
//  VideoTrimmerView.swift
//  Meninki
//
//  Created by Shirin on 3/8/23.
//

import UIKit
import EasyPeasy

class VideoTrimmerView: UIView {
    
    var header = Header(title: "trim_video", trailingIcon: UIImage(systemName: "checkmark"))
    
    var playerView = UIView()
    
    var trimmer = TrimmerView()
    
    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .white
        loading.backgroundColor = .black.withAlphaComponent(0.8)
        loading.layer.cornerRadius = 10
        loading.stopAnimating()
        return loading
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        trimmer.isHidden = true
        trimmer.handleColor = UIColor.white
        trimmer.mainColor = UIColor.orange
        trimmer.positionBarColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(){
        addSubview(header)
        header.easy.layout([
            Leading(), Trailing(), Top()
        ])
        
        addSubview(trimmer)
        trimmer.easy.layout([
            Leading(20), Trailing(20), Bottom(40).to(safeAreaLayoutGuide, .bottom), Height(100)
        ])
        
        addSubview(playerView)
        playerView.easy.layout([
            Top(20).to(header, .bottom), Leading(20), Trailing(20), Bottom(20).to(trimmer, .top)
        ])
        
        addSubview(loading)
        loading.easy.layout([
            CenterY().to(self, .centerY), CenterX(), Size(80)
        ])
    }
}
