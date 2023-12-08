//
//  ViewController.swift
//  AVAssetResourceLoader
//
//  Created by Pankaj Kulkarni on 24/11/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - Configure to use custom URL or HTTPS scheme
    /// When `isCustomScheme` is true, the resource url uses the custom scheme and then only
    /// the AVAssetResourceLoaderDelegate will come into picture.
    /// If `isCustomScheme` is false then it uses HTTPS scheme and AVPlayer will load the resource itself.
    let isCustomScheme = true
    
    var scheme: String {
        isCustomScheme ? customScheme : httpsScheme
    }
    let httpsScheme = "https"
    let customScheme = "customhttps"
    
    // Variable held though out the life cycle of the ViewController
    var session = URLSession.shared
    var receivedLoadingRequests: [String:AVAssetResourceLoadingRequest] = [:]
    
//    let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!
    let url = URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

