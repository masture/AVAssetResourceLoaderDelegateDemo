//
//  ViewController.swift
//  AVAssetResourceLoader
//
//  Created by Pankaj Kulkarni on 24/11/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - Configure to use custom URL scheme or HTTPS scheme
    /// When `isCustomScheme` is true, the resource url uses the custom scheme and then only
    /// the AVAssetResourceLoaderDelegate will come into picture.
    /// If `isCustomScheme` is false then it uses HTTPS scheme and AVPlayer will load the resource itself.
    let isCustomScheme = true
    
    var scheme: String {
        isCustomScheme ? customScheme : httpsScheme
    }
    let httpsScheme = "https"
    let customScheme = "customhttps"
    
    // Variable held throughout the life cycle of the ViewController
    var session: URLSession = {
        let config = URLSession.shared.configuration
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: config)
        return session
    }()
    var receivedLoadingRequests: [String:AVAssetResourceLoadingRequest] = [:]
    
//    let url = URL(string: "https://videos.files.wordpress.com/geVyynQI/big_buck_bunny_hd.mp4")!
//    let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!
//    let url = URL(string: "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")! // ✅ playing with current setup.
    let url = URL(string: "http://videos-cloudfront-usp.jwpsrv.com/6581f695_55fb946ed2dde6cac6cb822701f5f19b015cae1a/site/zWLy8Jer/media/vM7nH0Kl/version/21ETjILN/manifest.ism/manifest-audio_eng=112000-video_eng=550640.m3u8")!
//    let url = URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!
    
    lazy var urlAsset: AVURLAsset = {
        let customURL = url.withScheme(scheme)!
        let asset = AVURLAsset(url: customURL)
        asset.resourceLoader.setDelegate(self, queue: .main)
        print("Set the resource loader delegate.")
        return asset
    }()
    
    lazy var item = AVPlayerItem(asset: urlAsset)
    lazy var player = AVPlayer(playerItem: item)
    lazy var playerLayer = AVPlayerLayer(player: player)

    let aView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

