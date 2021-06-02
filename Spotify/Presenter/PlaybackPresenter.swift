//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Edo Lorenza on 01/06/21.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songTitle: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()

    private var track: AudioTrack?
    private var tracks = [AudioTrack]()

    var index = 0

    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let player = self.playerQueue, !tracks.isEmpty {
            return tracks[index]
        }

        return nil
    }

    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    var playerController: PlayerViewController?
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack){
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        self.track = track
        self.tracks = []
        
        let controller = PlayerViewController()
        controller.dataSource = self
        controller.delegate = self
        
        viewController.present(UINavigationController(rootViewController: controller), animated: true) {[weak self]  in
            self?.player?.play()
        }
        self.playerController = controller
    }
    
     func startPlayback(
        from viewController: UIViewController,
        track: [AudioTrack]){
        
        
            
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap ({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
           return AVPlayerItem(url: url)
        }))
        
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()
        
        self.tracks = track
        self.track = nil
        
        let controller = PlayerViewController()
        controller.dataSource = self
        controller.delegate = self
        
        
        viewController.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
   
}


extension PlaybackPresenter: PlayerDataSource {
    var songTitle: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string:currentTrack?.album?.images.first?.url ?? "")
    }
}


extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        
        
        else if let playerQueue = playerQueue {
            if playerQueue.timeControlStatus == .playing {
                playerQueue.pause()
            }
            else if playerQueue.timeControlStatus == .paused {
                playerQueue.play()
            }
        }
        
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            //not playlist or album
            player?.pause()
            player?.play()
        } else if let player = playerQueue {
            player.advanceToNextItem()
            index += 1
            playerController?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            //not playlist or album
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items().first{
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0.5
        }
    }
    
}
