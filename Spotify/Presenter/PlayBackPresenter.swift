//
//  PlayBackPresenter.swift
//  Spotify
//
//  Created by Oday Dieg on 01/03/2022.
//

import Foundation
import UIKit
import AVFoundation



final class PlayBackPresenter{
    
    
    static let shared = PlayBackPresenter()
    
    public var track:AudioTracks?
    
    private var tracks = [AudioTracks]()
    
    public var player:AVPlayer?
    
    public var playerQueue:AVQueuePlayer?
    
    var playerVC:PlayerViewController?
    
    public var index = 0
    
    var previousTrack:AudioTracks?
    
    private var currentTrack:AudioTracks?{
        
        get{
            if let track = track , tracks.isEmpty{
                
                return track
            }
            else if  !tracks.isEmpty {
                
                return tracks[index]
                
            }
            return nil
            
        }
        set {
            
            previousTrack = newValue
            
        }
        
        
    }
    
    
    func StartPlayBack(from viewcontroller:UIViewController , track: AudioTracks){
        
        guard let url = URL(string: track.preview_url ?? "") else{
            return
        }
        
        player = AVPlayer(url: url)
        
            self.track = track
            self.tracks = []
            let vc = PlayerViewController()
        vc.title = track.name
        vc.delegate = self
        vc.dataSource = self
        viewcontroller.present(UINavigationController(rootViewController: vc), animated: true) { [weak self]  in
            
            self?.player?.allowsExternalPlayback = true
            self?.player?.play()
        }
        self.playerVC = vc
        
    }
    
    
    
    func StartPlayBack(from viewcontroller:UIViewController , tracks: [AudioTracks]){
        
        
        
        let items:[AVPlayerItem] = tracks.compactMap {
            
            guard let url = URL(string: $0.preview_url ?? "")else{
                return nil
            }
            return AVPlayerItem(url: url)
        }
        
        self.tracks = tracks
        self.track = nil
        
        
        playerQueue = AVQueuePlayer(items: items)
        let vc = PlayerViewController()
        vc.delegate = self

        vc.dataSource = self
        viewcontroller.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        
        playerQueue?.play()
        self.playerVC = vc
    }
    
    
    
    func playTrackInIndex( with track:AudioTracks, alltracks: [AudioTracks]){
        
        
        guard let url = URL(string: track.preview_url ?? "") else{
            return
        }
        let playerItem = AVPlayerItem(url: url)
        playerQueue?.replaceCurrentItem(with: playerItem)
        playerQueue?.play()
        self.tracks = []
        self.tracks = alltracks
        self.playerVC?.RefreshUI()
    }
    
}




//MARK: - extensions to set data



extension PlayBackPresenter:PlayerDataSource {
    
    var title: String? {
        print("test from presenter \(index)")
        print(" from presenter \(currentTrack?.name ?? "error")")
        return currentTrack?.name
    }
    
    var subTitle: String? {
        return currentTrack?.artists.first?.name
        
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
        
    }
    
    
    
}


//MARK: - extension to handle button

extension PlayBackPresenter: PlayerViewControllerDelegate {
    
    
    
    func didSlideSliderBtn(_ value: Float) {
        player?.volume = value
        
        playerQueue?.volume = value
        
    }
    
    
    func didTapPlayPauseBtn() {
        
        
        // if player is single track
        if let player = player {
            
            
            if player.timeControlStatus == .playing{
                player.pause()
                
            }else {
                player.play()
            }
            
        }
        
        // if player is  playlist or album
        if let player = playerQueue {
            
            if player.timeControlStatus == .playing{
                player.pause()
            }else {
                player.play()
            }
            
        }
        
        
    }
    
    func didTapNextBtn() {
        
        if tracks.isEmpty {
            
            // when press next in single track
            
        }
        
        if tracks.count > index+1 {
            index += 1
            currentTrack = tracks[index]
            guard let next = previousTrack else {
                return
            }
            playTrackInIndex(with: next, alltracks: tracks)
            print("clicked next and index is \(index)")
            
        }
        
    }
    
    func didTapBackwardBtn() {
        
        if tracks.isEmpty {
            
            player?.seek(to: .zero)
            player?.play()
            
        }else if index != 0 {
            
            index -= 1
            currentTrack = tracks[index]
            guard let previous = previousTrack else {
                return
            }
            print("clicked back and index is \(index)")
            playTrackInIndex(with: previous,alltracks: tracks)
            
            
            
        }
        
    }
    
    
}

