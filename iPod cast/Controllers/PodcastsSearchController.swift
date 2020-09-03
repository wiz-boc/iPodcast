//
//  PodcastsSearchController.swift
//  iPod cast
//
//  Created by wiz on 9/2/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
	
	var podcasts = [
		Podcast(trackName: "Learning swift", artistName: "wiz"),
		Podcast(trackName: "Lets build that app", artistName: "Brain Voong"),
		Podcast(trackName: "Code with chris", artistName: "Chris")
	]
	
	let cellId = "cellId"
	
	//lets implement a UISearchController
	let searchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupSearchBar()
		setupTableView()
	}
	
	//MARK:- Setup work
	fileprivate func setupSearchBar(){
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
	}
	
	fileprivate func setupTableView(){
		//register a cell for tableview
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		//print(searchText)
		
		//let url = "http://itunes.apple.com/search?term=\(searchText)"
		let url = "http://itunes.apple.com/search"
		let parameters = ["term": searchText, "media": "podcast"]
		AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
			if let err = dataResponse.error {
				print("failed to contact google", err)
			}
			guard let data = dataResponse.data else {
				return
			}
			do{
				let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
				self.podcasts = searchResult.results
				self.tableView.reloadData()
			}catch let decodeErr {
				print("Failed to decode:", decodeErr)
			}
		}
	}
	
	struct SearchResults: Decodable {
		let resultCount: Int
		let results: [Podcast]
	}
	
	//MARK:- UITableview
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return podcasts.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		
		let podcast = self.podcasts[indexPath.row]
		cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
		cell.textLabel?.numberOfLines = -1
		cell.imageView?.image = #imageLiteral(resourceName: "appicon")
		return cell
	}
}
