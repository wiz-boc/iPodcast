//
//  EpisodesController.swift
//  iPod cast
//
//  Created by wiz on 9/6/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
	
	fileprivate let cellId = "cellId"
	var episodes = [Episode]()
	
	var podcast: Podcast? {
		didSet {
			navigationItem.title = podcast?.trackName
			fetchEpisodes()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}
	
	fileprivate func fetchEpisodes(){
		print("Looking for episodes at feed url:", podcast?.feedUrl ?? "")
		
		guard let feedURL = podcast?.feedUrl else { return }
		APIService.shared.fetchEpisodes(feedURL: feedURL) { (episodes) in
			self.episodes = episodes
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	
	
	//MARK:- Setup work
	fileprivate func setupTableView(){
		
		let nib = UINib(nibName: "EpisodeCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: cellId)
		tableView.tableFooterView = UIView()
	}
	
	//MARK:- UITableview
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let activityIndicatorView = UIActivityIndicatorView(style: .large)
		activityIndicatorView.color = .darkGray
		activityIndicatorView.startAnimating()
		return activityIndicatorView
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return episodes.isEmpty ? 200 : 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return episodes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else { fatalError("Episode cell fail to load ")}
		let episode = episodes[indexPath.row]
		cell.episode = episode

		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 134
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let episode = self.episodes[indexPath.row]
		
		let mainTabBarController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? MainTabBarController
		//let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
		mainTabBarController?.maximizePlayerDetails(episode: episode)
//		let episode = self.episodes[indexPath.row]
//		print("trying to play episode:", episode.title)
//
//		let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//		let playerDetailsView = PlayerDetailsView.initFromNib()
//
//		playerDetailsView.episode = episode
//
//		playerDetailsView.frame = self.view.frame
//		window?.addSubview(playerDetailsView)
//
//		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}
