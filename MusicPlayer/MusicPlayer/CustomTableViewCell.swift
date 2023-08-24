//
//  CustomTableViewCell.swift
//  MusicPlayer
//
//  Created by Tobi on 24/08/2023.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    
    func config(thisAudio: Audio){
        thumbnailImageView.image = UIImage(named: thisAudio.thumbnailSource)
        titleLabel.text = thisAudio.title
        artistLabel.text = thisAudio.artist
    }
}
