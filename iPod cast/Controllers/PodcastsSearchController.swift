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
	
	var podcasts = [Podcast]()
	let cellId = "cellId"
	
	//lets implement a UISearchController
	let searchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupSearchBar()
		setupTableView()
		
		searchBar(searchController.searchBar, textDidChange: "Voong")
	}
	
	//MARK:- Setup work
	fileprivate func setupSearchBar(){
		self.definesPresentationContext = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
	}
	
	fileprivate func setupTableView(){
		
		//register a cell for tableview
		//tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
		tableView.tableFooterView = UIView()
		let nib = UINib(nibName: "PodcastCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: cellId)
	}
	
	var footerHeight: CGFloat = 200
	var headerHeight: CGFloat = 0
	var timer: Timer?
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		//print(searchText)
		
		podcasts = []
		tableView.reloadData()
		
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
			APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
				self.podcasts = podcasts
				self.tableView.reloadData()
				if podcasts.isEmpty {
					self.headerHeight = 200
					self.footerHeight = 0
				}else{
					self.headerHeight = CGFloat(0)
					self.footerHeight = CGFloat(200)
				}
			}
		})
		
	}

	
	//MARK:- UITableview
	
	var podcastSearchView = Bundle.main.loadNibNamed("PodcastsSearchingView", owner: self, options: nil)?.first as? UIView
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return podcastSearchView
	}
	
	
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? footerHeight : 0
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "Please enter a valid search Term"
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		label.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
		return label
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return self.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : headerHeight
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let episodesController = EpisodesController()
		let podcast = self.podcasts[indexPath.row]
		episodesController.podcast = podcast
		navigationController?.pushViewController(episodesController, animated: true)
	}
	
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return podcasts.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PodcastCell else {
			fatalError("fail to load cell")
		}
		
		let podcast = self.podcasts[indexPath.row]
		cell.podcast = podcast
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 132
	}
}
