//
//  RSSFeed.swift
//  iPod cast
//
//  Created by wiz on 9/6/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import FeedKit

extension RSSFeed {
	func toEpisodes()-> [Episode] {
		
		let imageUrl = iTunes?.iTunesImage?.attributes?.href
		
		var episodes = [Episode]()
		items?.forEach({ (feedItem) in
			
			var episode = Episode(feedItem: feedItem)
			
			if episode.imageUrl == nil {
				episode.imageUrl = imageUrl
			}
			episodes.append(episode)
		})
		return episodes
	}
}
