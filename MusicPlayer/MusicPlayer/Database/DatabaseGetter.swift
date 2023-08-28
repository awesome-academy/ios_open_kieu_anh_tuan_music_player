//
//  DatabaseGetter.swift
//  MusicPlayer
//
//  Created by Tobi on 29/08/2023.
//

import Foundation

class DatabaseGetter {
    func getAudios() -> [Audio] {
        return [
            Audio(thumbnailImageView: "song1", titleLabel: "Lần cuối", artistLabel: "Ngọt", url: "song1"),
            Audio(thumbnailImageView: "song2", titleLabel: "Bohemian Rhapsody", artistLabel: "Queen", url: "song2"),
            Audio(thumbnailImageView: "song3", titleLabel: "A man without love", artistLabel: "Engelbert Humperdinck", url: "song3")
        ]
    }
}

