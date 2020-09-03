//
//  PodcastsSearchController.swift
//  iPod cast
//
//  Created by wiz on 9/2/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
	
	let podcasts = [
		Podcast(name: "Learning swift", artistName: "wiz"),
		Podcast(name: "Lets build that app", artistName: "Brain Voong"),
		Podcast(name: "Code with chris", artistName: "Chris")
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
		print(searchText)
	}
	
	//MARK:- UITableview
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return podcasts.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		
		let podcast = self.podcasts[indexPath.row]
		cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
		cell.textLabel?.numberOfLines = -1
		cell.imageView?.image = #imageLiteral(resourceName: "appicon")
		return cell
	}
}
