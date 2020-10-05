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
		setupNavigationBarButtons()
	}
	
	

	//MARK:- Setup work
	
	fileprivate func setupNavigationBarButtons(){
		//let's check if we already saved this podcasr as fav
		let savedPodcasts = UserDefaults.standard.savedPodcasts()
		let hasFavorited = savedPodcasts.firstIndex(where: {$0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName}) != nil
		if hasFavorited {
			//setting up out heart icon
			navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
		}else{
			navigationItem.rightBarButtonItems = [
				UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
//				UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts)),
			]
		}
			
	}
	
	@objc fileprivate func handleFetchSavedPodcasts(){
		
		do{
			guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return }
			//let podcast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Podcast
			
			let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast]
			savedPodcasts?.forEach({(p) in
				print(p.trackName ?? "")
			})
			//let podcast = try NSKeyedUnarchiver.unarchivedObject(ofClass: Podcast.self, from: data)
			print(podcast?.artistName ?? "")
		}catch{
			print("Failed to unarchieve data : \(error.localizedDescription) ")
		}
	}
	
	@objc fileprivate func handleSaveFavorite(){
		print("Saving info into UserDefaults")
		guard let podcast = self.podcast else {
			return
		}
		
		do {
			
			var listOfPodcasts = UserDefaults.standard.savedPodcasts()
			listOfPodcasts.append(podcast)
			
			let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
			UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
		
			showBadgeHighlight()
			navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
		}catch  {
			print("Could not archieve podcast : \(error.localizedDescription)")
		}
		
	}
	
	fileprivate func showBadgeHighlight(){
		UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
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
		let mainTabBarController = UIApplication.mainTabBarController()
		mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
		
	}
//	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//		<#code#>
//	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return UISwipeActionsConfiguration(actions: [
			makeCompleteContextualAction(forRowAt: indexPath)
		])
	}
	
	private func makeCompleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
		return UIContextualAction(style: .normal, title: "Download") { (action, swipeButtonView, completion) in
//			action.image = ProjectImages.Annotation.checkmark
//			action.image?.withTintColor(.systemGreen)
//			action.backgroundColor = .systemOrange
			print("Downloading episode into userdefaults")
			let episode = self.episodes[indexPath.row]
			UserDefaults.standard.downloadEpisode(episode: episode)
			
			APIService.shared.downloadEpisode(episode: episode)
			//download the podcast episode using elamofire
			completion(true)
		}
	}
	
	
}
