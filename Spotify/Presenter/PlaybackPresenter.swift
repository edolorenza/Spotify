//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Edo Lorenza on 01/06/21.
//

import UIKit

final class PlaybackPresenter {
    
    static func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack){
        
        let controller = PlayerViewController()
        viewController.present(controller, animated: true, completion: nil)
    }
    
    static func startPlayback(
        from viewController: UIViewController,
        track: [AudioTrack]){
        
        let controller = PlayerViewController()
        viewController.present(controller, animated: true, completion: nil)
    }
    
   
}

