//
//  PlayerDetailsView.swift
//  iPod cast
//
//  Created by wiz on 9/7/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit
import AVKit

class PlayerDetailsView: UIView {
	
	var episode: Episode! {
		didSet {
			episodeTitleLabel.text = episode.title
			authorLabel.text = episode.author
			
			playEpisode()
			
			guard let url = URL(string: episode.imageUrl ?? "") else {return }
			episodeImageView.sd_setImage(with: url, completed: nil)
		}
	}
	
	fileprivate func playEpisode(){
		print("Trying to play podcast at url:", episode.streamUrl)
		
		guard let url = URL(string: episode.streamUrl) else { return }
		let playerItem = AVPlayerItem(url: url)
		player.replaceCurrentItem(with: playerItem)
		player.play()
	}
	
	let player: AVPlayer = {
		let avPlayer = AVPlayer()
		avPlayer.automaticallyWaitsToMinimizeStalling = false
		return avPlayer
	}()
	
	//MARK:- IB Actions and Outlets
	
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var episodeImageView: UIImageView!
	
	@IBOutlet weak var playPauseTapped: UIButton!{
		didSet {
			playPauseTapped.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
			playPauseTapped.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
		}
	}
	
	@objc func handlePlayPause(){
		if player.timeControlStatus == .paused {
			playPauseTapped.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
			player.play()
		}else{
			playPauseTapped.setImage(#imageLiteral(resourceName: "play"), for: .normal)
			player.pause()
		}
	}
	
	@IBOutlet weak var episodeTitleLabel: UILabel! {
		didSet {
			episodeTitleLabel.numberOfLines = 0
		}
	}
	@IBAction func dismissTapped(_ sender: Any) {
		self.removeFromSuperview()
	}
}
