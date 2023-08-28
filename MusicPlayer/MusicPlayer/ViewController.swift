//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Tobi on 22/08/2023.
//

import UIKit
import AVFoundation
import MediaPlayer

final class ViewController: UIViewController {
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    
    var selectedAudio: Audio?
    private var isPlaying = false
    private var player: AVPlayer?
    private var remoteCommandCenter = MPRemoteCommandCenter.shared()
    private var playCommand: Any?
    private var pauseCommand: Any?
    
    private let pauseRate: Double = 0
    private let playRate: Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        initPlayer()
        setupBackground()
        
        if let audio = selectedAudio {
            thumbnailImageView.image = UIImage(named: audio.thumbnailImageView)
            titleLabel.text = audio.titleLabel
            artistLabel.text = audio.artistLabel
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeCommandCenter()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction private func playButtonPressed(_ sender: UIButton) {
        isPlaying
            ? ( self.configureState(AudioState.pause),
            MPNowPlayingInfoCenter.default().playbackState = .paused )
            : ( self.configureState(AudioState.play),
            MPNowPlayingInfoCenter.default().playbackState = .playing )
        
        addActionsToControlCenter()
        updateInfoCenter()
    }
    
    private func initPlayer() {
        guard let url = Bundle.main.url(forResource: selectedAudio?.url, withExtension: "mp3")
        else {
            return
        }
        
        player = AVPlayer(url: url)
    }
    
    private func setupBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error when setup background")
        }
    }
    
    private func removeCommandCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        MPNowPlayingInfoCenter.default().playbackState = .stopped
        remoteCommandCenter.playCommand.isEnabled = false
        remoteCommandCenter.playCommand.removeTarget(playCommand)
        remoteCommandCenter.pauseCommand.isEnabled = false
        remoteCommandCenter.pauseCommand.removeTarget(pauseCommand)
    }
    
    private func addActionsToControlCenter() {
        remoteCommandCenter.playCommand.isEnabled = true
        remoteCommandCenter.pauseCommand.isEnabled = true
                        
        playCommand = remoteCommandCenter.playCommand.addTarget { event in
            self.configureCommand(.play)
        }
        pauseCommand = remoteCommandCenter.pauseCommand.addTarget { event in
            self.configureCommand(.pause)
        }
    }
    
    private func configureCommand(_ command: MPRemoteCommandType) -> MPRemoteCommandHandlerStatus {
        var rate: Double?
        
        switch command {
        case .play:
            self.configureState(AudioState.play)
            rate = self.playRate
        case .pause:
            self.configureState(AudioState.pause)
            rate = self.pauseRate
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player?.currentTime().seconds
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = rate
        
        return .success
    }
    
    private func configureState(_ audioState: AudioState) {
        switch audioState {
        case .pause:
            self.player?.pause()
            self.isPlaying = false
            self.playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        case .play:
            self.player?.play()
            self.isPlaying = true
            self.playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        default:
            print("Invalid")
        }
    }
    
    private func updateInfoCenter() {
        guard let selectedItem = selectedAudio else {return}
        
        var nowPlayingInfo : [String : Any] = [
            MPMediaItemPropertyTitle: selectedItem.titleLabel,
            MPMediaItemPropertyArtist: selectedItem.artistLabel,
            MPMediaItemPropertyPlaybackDuration: player?.currentItem?.duration.seconds ?? 0,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player?.currentTime().seconds ?? 0,
        ]
        
        if let image = UIImage(named: selectedItem.url) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (size) -> UIImage in
                return image
            })
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}


