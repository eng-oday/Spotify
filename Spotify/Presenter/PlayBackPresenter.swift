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
    
    private var currentTrack:AudioTracks?{
        
        // lw el tracks fadia ya3ni m4 m48l play list we m48l one track return this one
        if let track = track , tracks.isEmpty{
            
            return track
        }
        
        // law m48l play list yeb2a el tracks m4 fadia yeb2a return first track in this [tracks]
        else if let player = self.playerQueue , !tracks.isEmpty {
        
            return tracks[index]
            
        }
        
        return nil
        
    }

    
    func StartPlayBack(from viewcontroller:UIViewController , track: AudioTracks){
    
        guard let url = URL(string: track.preview_url ?? "") else{
            return
        }
    
        player = AVPlayer(url: url)
        
        DispatchQueue.main.async {
            self.track = track
            self.tracks = []
        }
      
       let vc = PlayerViewController()
       vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
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
     
         vc.dataSource = self
         vc.delegate = self

        viewcontroller.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
         
         playerQueue?.play()
         self.playerVC = vc
    }
  
}




//MARK: - extensions to set data



extension PlayBackPresenter:PlayerDataSource {
    
    var title: String? {
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

    
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
        
        playerQueue?.volume = value
        
    }
    
    
    func didTapPlayPause() {


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

    
    func didTapNext() {
        
        guard let player = playerQueue else{
            return
        }
        
        if tracks.isEmpty {
            
        }
        
        if tracks.count > index+1 {
            player.advanceToNextItem()
            index += 1
            playerVC?.RefreshUI()
            
        }

    }
    
    func didTapBackward() {
        
        if tracks.isEmpty {
            
           player?.pause()

            player?.play()
            
        }else {
      
            playerQueue?.removeAllItems()
        
        }
        
    }
    
    
    
    
    
}


//
