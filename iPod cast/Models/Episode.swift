//
//  Episode.swift
//  iPod cast
//
//  Created by wiz on 9/6/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
	let title: String
	let pubDate: Date
	let description: String
	var imageUrl: String?
	var author: String
	
	init(feedItem: RSSFeedItem) {
		self.title = feedItem.title ?? ""
		self.pubDate = feedItem.pubDate ?? Date()
		self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
		self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
		self.author = feedItem.iTunes?.iTunesAuthor ?? ""
	}
	
}
