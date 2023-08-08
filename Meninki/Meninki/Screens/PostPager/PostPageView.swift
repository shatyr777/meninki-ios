//
//  PostPageView.swift
//  Meninki
//
//  Created by Shirin on 4/3/23.
//

import UIKit
import EasyPeasy
import AVFoundation

class PostPageView: UIView {

    var content = UIView()

    var footer = PostFooter()
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 12,
                                   edgeInsets: UIEdgeInsets(edges: 14))
    
    var verticalBtnWrapper = UIView()
    
    var verticalBtnStack = UIStackView(axis: .vertical,
                                       alignment: .fill,
                                       spacing: 33)
    
    var likeBtn = FeedCellBtn(icon: UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate),
                              axis: .vertical)
    
    var shareBtn = FeedCellBtn(icon: UIImage(named: "share")?.withRenderingMode(.alwaysTemplate),
                              axis: .vertical)

    var userStack = UIStackView(axis: .horizontal,
                                alignment: .fill,
                                spacing: 10)
    
    var userName = UILabel(font: .lil_14,
                           color: .bg,
                           alignment: .left,
                           numOfLines: 1,
                           text: "@username")
    
    var subscribeBtn = SubscribeBtn()
    
    var desc = UILabel(font: .lil_12,
                       color: .bg,
                       alignment: .left,
                       numOfLines: 0,
                       text: "desc of post here")
    
    var pageControlWrapper = UIView()
    
    var pageControl: UIPageControl = {
        let p = UIPageControl()
        p.numberOfPages = 10
        p.currentPage = 3
        p.hidesForSinglePage = true
        if #available(iOS 14.0, *) {
            p.backgroundStyle = .minimal
        }
        return p
    }()
    
    var playerView = UIView()
    
    var imgList = PostImageListView()
    
    var player: AVPlayer?
    var asset: AVAsset?

    override init(frame: CGRect) {
        super.init(frame: frame)
        playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerViewClick)))
        setupView()
        setupContentStack()
        
        subscribeBtn.isSubscribed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(footer)
        footer.easy.layout([
            Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
        
        addSubview(content)
        content.layer.cornerRadius = 10
        content.easy.layout([
            Top(4), Leading(4), Trailing(4), Bottom().to(footer, .top)
        ])
        
        addSubview(contentStack)
        contentStack.easy.layout([
            Leading(4), Trailing(4), Bottom().to(footer, .top)
        ])
        
        addSubview(verticalBtnStack)
        verticalBtnStack.easy.layout([
            Trailing(14), Bottom().to(contentStack, .top)
        ])
    }
    
    func setupContentStack(){
        contentStack.addArrangedSubviews([pageControlWrapper,
                                          userStack,
                                          desc])
        
        verticalBtnStack.addArrangedSubviews([likeBtn,
                                              shareBtn])

        pageControlWrapper.addSubview(pageControl)
        pageControl.easy.layout([
            Top(), Bottom(), CenterX(), Height(30)
        ])

        userStack.addArrangedSubviews([userName,
                                       subscribeBtn,
                                       UIView()])
    }
    
    func setupVideo(data: [Media]){
        pageControl.isHidden = true
        imgList.removeFromSuperview()
        content.addSubview(playerView)
        playerView.easy.layout(Edges())

        let asset = AVAsset(url: URL(string: "https://meninki.com.tm"+(data.first?.path ?? ""))!)
        addVideoPlayer(with: asset, playerView: playerView)
    }
    
    func setupImages(data: [Media]){
        playerView.removeFromSuperview()
        content.addSubview(imgList)
        imgList.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        imgList.data = data
        pageControl.numberOfPages = data.count
        pageControl.currentPage = 0
    }
    
    func setupData(data: Post?){
        guard let data = data else { return }
        let isLiked = data.rating?.userRating?.keys.contains(where: { $0 == AccUserDefaults.id }) ?? false
        likeBtn.icon.image = UIImage(named: isLiked ? "heart-filled" : "heart")
        likeBtn.count.text = "\(data.rating?.total ?? 0)"

        footer.img.kf.setImage(with: ApiPath.getUrl(path: data.productMedia ?? ""))
        footer.desc.text = data.productTitle
        shareBtn.count.text = ""
        userName.text = data.user?.userName ?? data.user?.name
        desc.text = data.description
        subscribeBtn.isSubscribed = data.user?.isSubscribed ?? false
        if data.medias.first?.mediaType == MediaType.video.rawValue {
            setupVideo(data: data.medias)
        } else {
            setupImages(data: data.medias)
            imgList.pageChanged = { [weak self] page in
                self?.pageControl.currentPage = page
            }
        }
    }
    
    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 0,
                             y: 0,
                             width: DeviceDimensions.width,
                             height: DeviceDimensions.safeAreaHeight)
        
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
    }
    
    @objc func playerViewClick() {
        if player?.isPlaying == true  {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
    }
}


