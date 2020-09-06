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
	
	
	struct Episode {
		let title: String
	}
	
	fileprivate let cellId = "cellId"
	var episodes = [Episode]()
	
	var podcast: Podcast? {
		didSet {
			navigationItem.title = podcast?.trackName
			fetchEpisodes()
		}
	}
	
	fileprivate func fetchEpisodes(){
		print("Looking for episodes at feed url:", podcast?.feedUrl ?? "")
		
		guard let feedURL = podcast?.feedUrl else { return }
		let secureFeedURL = feedURL.contains("https") ? feedURL : feedURL.replacingOccurrences(of: "http", with: "https")
		guard let url = URL(string: secureFeedURL) else {return }
		let parser = FeedParser(URL: url)
		parser.parseAsync { (result) in
			print("Sccuessfully parse feed:",result)
			
			switch result {
				case .success(let feed):
					
					var episodes = [Episode]()
					//feed.rssFeed
					switch feed {
						case let .rss(feed):
							feed.items?.forEach({ (feedItem) in
								
								let episode = Episode(title: feedItem.title ?? "")
								episodes.append(episode)
								print("Feed title :",feedItem.title ?? "")
							})
							self.episodes = episodes
							DispatchQueue.main.async {
								self.tableView.reloadData()
							}
							break
						default:
							print("Found a feed...")
					}
				
				case .failure(let error):
					print("Failed to parse feed: ",error)
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}
	
	//MARK:- Setup work
	fileprivate func setupTableView(){
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
		tableView.tableFooterView = UIView()
	}
	
	//MARK:- UITableview
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return episodes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		let episode = episodes[indexPath.row]
		cell.textLabel?.text = episode.title
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}
