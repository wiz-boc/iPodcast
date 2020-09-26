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
			miniTitleLabel.text = episode.title
			
			
			playEpisode()
			
			guard let url = URL(string: episode.imageUrl ?? "") else {return }
			episodeImageView.sd_setImage(with: url, completed: nil)
			miniEpisodeImageView.sd_setImage(with: url)
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
	
	fileprivate func observePlayerCurrentTime() {
		let interval = CMTimeMake(value: 1, timescale: 2)
		player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
			self?.currentTImeLabel.text = time.toDisplayString()
			
			let durationTime = self?.player.currentItem?.duration
			self?.durationTimeLabel.text = durationTime?.toDisplayString()
			self?.updateCurrentTimeSlider()
		}
	}
	
	fileprivate func updateCurrentTimeSlider(){
		
		let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
		let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
		
		let percentage = currentTimeSeconds / durationSeconds
		self.currentTimeSlider.value = Float(percentage)
	}
	
	var panGesture: UIPanGestureRecognizer!
	fileprivate func setupGestures() {
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
		observePlayerCurrentTime()
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
		
		miniPlayerView.addGestureRecognizer(panGesture)
		maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
		//addGestureRecognizer(panGesture)
	}
	@objc func handleDismissalPan(gesture: UIPanGestureRecognizer){
		print("maximized SV dismissal")
		if gesture.state == .changed {
			let translation = gesture.translation(in: superview)
			maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
		}else if gesture.state == .ended {
			let translation = gesture.translation(in: superview)
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.maximizedStackView.transform = .identity
				
				if translation.y > 50 {
					UIApplication.mainTabBarController()?.minimizePlayerDetails()
					//gesture.isEnabled = false
				}
			})
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupGestures()
		let time = CMTimeMake(value: 1, timescale: 3)
		let times = [NSValue(time: time)]
		
		//Player has a reference to self
		//self has a reference to player
		player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
			print("Episode started playing")
			self?.enlargeEpisodeImageView()
		}
	}
	
	
	
	static func initFromNib() -> PlayerDetailsView {
		return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
	}
	deinit {
		print("PlayerDetailsView memory being reclaimed")
	}
	
	//MARK:- IB Actions and Outlets
	
	
	@IBOutlet weak var miniEpisodeImageView: UIImageView!
	@IBOutlet weak var miniTitleLabel: UILabel!
	@IBOutlet weak var miniPlayPauseButton: UIButton! {
		didSet {
			miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
			miniPlayPauseButton.imageView?.contentMode = .scaleAspectFit
			miniPlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		}
	}
	@IBOutlet weak var miniFastForwardButton: UIButton! {
		didSet {
			miniFastForwardButton.imageView?.contentMode = .scaleAspectFit
			miniFastForwardButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		}
	}
	@IBOutlet weak var miniPlayerView: UIView!
	@IBOutlet weak var maximizedStackView: UIStackView!
	@IBOutlet weak var currentTimeSlider: UISlider!
	@IBOutlet weak var durationTimeLabel: UILabel!
	@IBOutlet weak var currentTImeLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var episodeImageView: UIImageView! {
		didSet {
			episodeImageView.layer.cornerRadius = 5
			episodeImageView.clipsToBounds = true
			episodeImageView.transform = self.shrunkenTransform
		}
	}
	
	@IBOutlet weak var playPauseTapped: UIButton!{
		didSet {
			playPauseTapped.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
			playPauseTapped.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
		}
	}
	
	@objc func handlePlayPause(){
		if player.timeControlStatus == .paused {
			playPauseTapped.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
			miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
			player.play()
			enlargeEpisodeImageView()
		}else{
			playPauseTapped.setImage(#imageLiteral(resourceName: "play"), for: .normal)
			miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
			player.pause()
			shrinkEpisodeImageView()
		}
	}
	
	@IBOutlet weak var episodeTitleLabel: UILabel! {
		didSet {
			episodeTitleLabel.numberOfLines = 0
		}
	}
	fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
	fileprivate func shrinkEpisodeImageView(){
		UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.episodeImageView.transform = self.shrunkenTransform
		})
	}
	
	fileprivate func enlargeEpisodeImageView(){
		UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.episodeImageView.transform = .identity
		})
	}
	@IBAction func dismissTapped(_ sender: Any) {
		//self.removeFromSuperview()
		UIApplication.mainTabBarController()?.minimizePlayerDetails()
		//panGesture.isEnabled = true
	}
	
	@IBAction func handleCurrentTimeSliderChanged(_ sender: UISlider) {
		let percentage = currentTimeSlider.value
		guard let duration = player.currentItem?.duration else { return }
		let durationInSeconds = CMTimeGetSeconds(duration)
		let seekTimeInSeconds = Float64(percentage) * durationInSeconds
		
		//Int32(NSEC_PER_SEC)
		let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
		
		player.seek(to: seekTime)
	}
	@IBAction func handleRewind(_ sender: UIButton) {
		seekToCurrentTime(delta: -15)
	}
	
	fileprivate func seekToCurrentTime(delta: Int64) {
		let fifteenSeconds = CMTimeMake(value: delta,timescale: 1)
		let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
		player.seek(to: seekTime)
	}
	
	@IBAction func handleFastForward(_ sender: UIButton) {
		seekToCurrentTime(delta: 15)
	}
	@IBAction func handleVolumeChangeSlider(_ sender: UISlider) {
		player.volume = sender.value
	}
}
