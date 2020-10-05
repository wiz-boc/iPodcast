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
		setupObservers()
	}
	fileprivate func setupObservers(){
		NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
	}
	
	@objc fileprivate func handleDownloadComplete(notification: Notification){
		
		episodes = UserDefaults.standard.downloadEpisodes()
		guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
		
		guard let index = self.episodes.firstIndex(where: { $0.title ==  episodeDownloadComplete.episodeTitle }) else { return }
		
		self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
	}
	@objc fileprivate func handleDownloadProgress(notification: Notification){
		guard let userInfo = notification.userInfo as? [String: Any] else { return }
		guard let progress = userInfo["progress"] as? Double else { return}
		
		guard let title = userInfo["title"] as? String else { return }
		print(progress,title)
		
		
		//let find the index using title
		guard let index = self.episodes.firstIndex(where: { $0.title ==  title }) else { return }
		guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
		cell.progressLabel.isHidden = false
		cell.progressLabel.text = "\(Int(progress * 100))%"
		if progress == 1 {
			cell.progressLabel.isHidden = true
		}
		
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
		
		if episode.fileUrl != nil {
			UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
		}else{
			let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play stream url instead", preferredStyle: .actionSheet)
			
			alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
				UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
			}))
			
			alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			present(alertController, animated: true, completion: nil)
		}
		
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
