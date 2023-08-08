//
//  VideoTrimmerVC.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit
import AVFoundation
import TLPhotoPicker
import Photos

class VideoTrimmerVC: UIViewController {
    
    var uploadVideo: UploadVideo!
    
    var phAsset: PHAsset?
    
    var player: AVPlayer?
    var asset: AVAsset?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?

    var doneClickCallback: ( (_ data: UploadVideo?)->() )?
    
    var mainView: VideoTrimmerView {
        return view as! VideoTrimmerView
    }
    
    override func loadView() {
        super.loadView()
        view = VideoTrimmerView()
        view.backgroundColor = .bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        configurePhAsset()
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.header.trailingBtn.clickCallback = { [weak self] in
            guard let self = self else { return }
            guard let asset = self.asset else { return }
            guard let outputMovieURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("exported.mov") else { return }

            self.export(asset,
                        to: outputMovieURL,
                        startTime: self.mainView.trimmer.startTime!,
                        endTime: self.mainView.trimmer.endTime!)
        }
    }
    
    func done(){
        if uploadVideo.image == nil || uploadVideo.path == nil { return }
        mainView.loading.stopAnimating()
        doneClickCallback?(uploadVideo)
        navigationController?.popViewController(animated: true)
    }

    func play() {
        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
        } else {
            player.pause()
            stopPlaybackTimeChecker()
        }
    }

    func configurePhAsset(){
        guard let asset = phAsset else { return }
        let manager = PHImageManager.default()
        
        switch asset.mediaType {
        case .image:
            break
            
        case .video:
            manager.requestAVAsset(forVideo: asset, options: .none) { avAsset, _, info in
                if info?["PHImageResultIsInCloudKey"] as? Int? == 1 {
                    PopUpLauncher.showErrorMessage(text: "could_not_download".localized())
                    return
                }
                
                DispatchQueue.main.async {
                    guard let ass = avAsset else { return }
                    ass.generateThumbnail { img in
                        self.uploadVideo.image = img
                    }
                    self.loadAsset(ass)
                }
            }
            
        default:
            return
        }

    }
    func loadAsset(_ asset: AVAsset) {
        self.asset = asset
        mainView.trimmer.isHidden = false
        mainView.trimmer.asset = asset
        mainView.trimmer.delegate = self
        addVideoPlayer(with: asset, playerView: mainView.playerView)
    }

    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
        player?.play()
    }


    func startPlaybackTimeChecker() {
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
            #selector(self.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }

    func stopPlaybackTimeChecker() {
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }
    
    func export(_ asset: AVAsset, to outputMovieURL: URL, startTime: CMTime, endTime: CMTime) {
        if endTime.seconds - startTime.seconds > 25 {
            PopUpLauncher.showErrorMessage(text: "video_duration_error".localized())
            return
        }
        
        mainView.loading.startAnimating()
        
        let timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        try? FileManager.default.removeItem(at: outputMovieURL)
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)

        exporter?.outputURL = outputMovieURL
        exporter?.outputFileType = .mov
        exporter?.timeRange = timeRange

        exporter?.exportAsynchronously(completionHandler: { [weak exporter] in
            DispatchQueue.main.async {
                if let error = exporter?.error {
                    debugPrint(error)
                    print("failed")
                } else {
                    self.uploadVideo.data = try? Data(contentsOf: outputMovieURL)
                    self.uploadVideo.path = outputMovieURL
                    self.done()
//                    self.player = nil
//                    self.loadAsset(AVAsset(url: outputMovieURL))
                }
            }
        })
    }


    @objc func itemDidFinishPlaying(_ notification: Notification) {
        if let startTime = mainView.trimmer.startTime {
            player?.seek(to: startTime)
            if (player?.isPlaying != true) {
                player?.play()
            }
        }
    }

    @objc func onPlaybackTimeChecker() {
        guard let startTime = mainView.trimmer.startTime, let endTime = mainView.trimmer.endTime, let player = player else {
            return
        }

        let playBackTime = player.currentTime()
        mainView.trimmer.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            mainView.trimmer.seek(to: startTime)
        }
    }
}

extension VideoTrimmerVC: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.play()
        startPlaybackTimeChecker()
    }

    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//        let duration = (mainView.trimmer.endTime! - mainView.trimmer.startTime!).seconds
    }
}





extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
