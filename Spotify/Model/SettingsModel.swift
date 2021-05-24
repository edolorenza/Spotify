//
//  SettingsModel.swift
//  Spotify
//
//  Created by Edo Lorenza on 24/05/21.
//

import Foundation

struct Section {
    let title: String
    let option: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
