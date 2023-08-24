//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Tobi on 22/08/2023.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    
    var selectedAudio: Audio?
    
    private var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        if let audio = selectedAudio {
            thumbnailImageView.image = UIImage(named: audio.thumbnailSource)
            titleLabel.text = audio.title
            artistLabel.text = audio.artist
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction private func playButtonPressed(_ sender: UIButton) {
        var imageSystemName: String
        isPlaying
        ? (imageSystemName = "play.circle.fill")
        : (imageSystemName = "pause.circle.fill")
        isPlaying.toggle()
        playButton.setImage(UIImage(systemName: imageSystemName), for: .normal)
    }
}

