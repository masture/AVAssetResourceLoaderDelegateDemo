//
//  ViewController + setupUI.swift
//  AVAssetResourceLoader
//
//  Created by Pankaj Kulkarni on 08/12/23.
//

import UIKit

extension ViewController {
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    func setupUI() {
        title = "AVAssetResourceLoader Demo"
        
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.backgroundColor = .systemGray
        view.addSubview(aView)
        NSLayoutConstraint.activate([
            aView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            aView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            aView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            aView.heightAnchor.constraint(equalTo: aView.widthAnchor, multiplier: 1080.0/1920.0 )
        ])
        
        let playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        playButton.setTitle("Play", for: .normal)
        view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: aView.bottomAnchor, constant: 16),
            playButton.heightAnchor.constraint(equalToConstant: 44),
            playButton.centerXAnchor.constraint(equalTo: aView.centerXAnchor)
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        //        playerLayer.removeFromSuperlayer()
        playerLayer.backgroundColor = UIColor.systemGreen.cgColor
        playerLayer.frame = CGRect(origin: .zero, size: aView.bounds.size)
        aView.layer.addSublayer(playerLayer)
    }
}

