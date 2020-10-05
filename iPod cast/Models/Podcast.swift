//
//  Podcast.swift
//  iPod cast
//
//  Created by wiz on 9/2/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import Foundation

class Podcast: NSObject, Decodable, NSCoding {
	func encode(with coder: NSCoder) {
		print("Tring to transform podcast into data")
		coder.encode(trackName ?? "", forKey: "trackNameKey")
		coder.encode(artistName ?? "", forKey: "artistNameKey")
		coder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
		coder.encode(trackCount ?? "", forKey: "trackCountKey")
		coder.encode(feedUrl ?? "", forKey: "feedUrlKey")
	}
	
	
	required init?(coder: NSCoder) {
		print("Tring to transform data into podcast")
		self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
		self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
		self.artworkUrl600 = coder.decodeObject(forKey: "artworkKey") as? String
		self.trackCount = coder.decodeObject(forKey: "trackCountKey") as? Int
		self.feedUrl = coder.decodeObject(forKey: "feedUrlKey") as? String
	}
	
	var trackName: String?
	var artistName: String?
	var artworkUrl600: String?
	var trackCount: Int?
	var feedUrl: String?
}
