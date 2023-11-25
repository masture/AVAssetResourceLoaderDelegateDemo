//
//  ViewController.swift
//  AVAssetResourceLoader
//
//  Created by Pankaj Kulkarni on 24/11/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let aView = UIView()
    let url = URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!
    lazy var urlAsset: AVAsset = {
        let asset = AVURLAsset(url: url)
        asset.resourceLoader.setDelegate(self, queue: .main)
        return asset
    }()
    lazy var item = AVPlayerItem(asset: urlAsset)
    lazy var player = AVPlayer(playerItem: item)
//    lazy var player = AVPlayer(url: url)
    lazy var playerLayer = AVPlayerLayer(player: player)
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    func setupUI() {
        
        
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.backgroundColor = .systemGray
        view.addSubview(aView)
        NSLayoutConstraint.activate([
            aView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            aView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            aView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            aView.heightAnchor.constraint(equalTo: aView.widthAnchor, multiplier: 1080.0/1920.0 )
        ])
        let action = UIAction(title: "Play") { [weak self] action in
            guard let self else { return }
            playerLayer.frame = CGRect(origin: .zero, size: aView.bounds.size)
            aView.layer.addSublayer(playerLayer)
            
            player.play()
        }
        let playButton = UIButton(primaryAction: action)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: aView.bottomAnchor, constant: 16),
            playButton.heightAnchor.constraint(equalToConstant: 44),
            playButton.centerXAnchor.constraint(equalTo: aView.centerXAnchor)
        ])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "AVAssetResourceLoader"
        
    }

}

// MARK: - AVAssetResourceLoaderDelegate

extension ViewController: AVAssetResourceLoaderDelegate {
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForResponseTo authenticationChallenge: URLAuthenticationChallenge) -> Bool {
//        print("")
//        return true
//    }
    
}
