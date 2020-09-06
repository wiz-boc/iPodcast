//
//  APIService.swift
//  iPod cast
//
//  Created by wiz on 9/5/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
	
	let baseiTunesSearchURL = "http://itunes.apple.com/search"
	//singleton
	static let shared = APIService()
	
	
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
