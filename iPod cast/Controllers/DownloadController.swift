//
//  DownloadController.swift
//  iPod cast
//
//  Created by wiz on 10/3/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class DownloadController: UITableViewController {
	
	let cellId = "cellId"
	
	var episodes = UserDefaults.standard.downloadEpisodes()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTableView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		episodes = UserDefaults.standard.downloadEpisodes()
		tableView.reloadData()
	}
	
	fileprivate func setupTableView(){
		let nib = UINib(nibName: "EpisodeCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: cellId)
	}
	
	//MARK:- UITableView
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Launch episode player")
		
		let episode = self.episodes[indexPath.row]
		UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return episodes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else {
			fatalError("Something went wrong with cell")
		}
		cell.episode = episodes[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 134
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		self.episodes.remove(at: indexPath.row)
		return UISwipeActionsConfiguration(actions: [
			makeDeleteContextualAction(forRowAt: indexPath)
		])
		
	}
	
	//MARK: - Contextual Actions
	private func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
		  
		return UIContextualAction(style: .destructive, title: "Delete") { (action, swipeButtonView, completion) in
			
			UserDefaults.standard.deleteEpisode(episodes: self.episodes)
			print("DELETE HERE")
			completion(true)
			self.tableView.reloadData()
		}
	}
}
