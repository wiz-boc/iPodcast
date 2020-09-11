//
//  APIService.swift
//  iPod cast
//
//  Created by wiz on 9/5/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
	
	let baseiTunesSearchURL = "http://itunes.apple.com/search"
	//singleton
	static let shared = APIService()
	
	
	func fetchEpisodes(feedURL: String, completionHandler: @escaping ([Episode]) -> ()){
		let secureFeedURL = feedURL.contains("https") ? feedURL : feedURL.replacingOccurrences(of: "http", with: "https")
		guard let url = URL(string: secureFeedURL) else {return }
		
		DispatchQueue.global(qos: .background).async {
			let parser = FeedParser(URL: url)
			parser.parseAsync { (result) in
				print("Sccuessfully parse feed:",result)
				
				if case .failure(let error) = result {
					print("Failed to parse feed: ",error)
				}
				
				if case .success(let feedData) = result {
					
					guard let feed = feedData.rssFeed else { return }
					let episodes = feed.toEpisodes()
					completionHandler(episodes)
				}
			}
		}
		
			//			switch result {
			//				case .success(let feed):
			//
			//					//var episodes = [Episode]()
			//					//feed.rssFeed
			//					switch feed {
			//						case let .rss(feed):
			//							self.episodes = feed.toEpisodes()
			//							DispatchQueue.main.async {
			//								self.tableView.reloadData()
			//							}
			//							break
			//						default:
			//							print("Found a feed...")
			//					}
			//				case .failure(let error):
			//			}
		
	}
	
	func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()){
		//let url = "http://itunes.apple.com/search?term=\(searchText)"
		
		let parameters = ["term": searchText, "media": "podcast"]
		AF.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
			if let err = dataResponse.error {
				print("failed to contact google", err)
			}
			guard let data = dataResponse.data else {
				return
			}
			do{
				let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
				print(searchResult.resultCount)
				completionHandler(searchResult.results)
				//self.podcasts = searchResult.results
				//self.tableView.reloadData()
			}catch let decodeErr {
				print("Failed to decode:", decodeErr)
			}
		}
	}
	
	struct SearchResults: Decodable {
		let resultCount: Int
		let results: [Podcast]
	}
}
