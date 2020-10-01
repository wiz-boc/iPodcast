//
//  UserDefaults.swift
//  iPod cast
//
//  Created by wiz on 9/30/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import Foundation

extension UserDefaults {
	
	static let favoritedPodcastKey = "favouritedPodcastKey"
	func savedPodcasts() -> [Podcast] {
		do {
			guard let savedPodCastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else {
				return []
			}
			guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodCastsData) as? [Podcast] else {
				return []
			}
			
			return savedPodcasts
		} catch {
			print("Could not retrieve archiever data:",error)
		}
		return []
	}
	
	func deletePodcast(podcasts: [Podcast]) {
		
		do{
//			let podcasts = savedPodcasts()
//			let filteredPodcasts = podcasts.filter { (p) -> Bool in
//				return p.trackName != podcast.trackName && p.artistName != podcast.artistName
//			}
			let data = try NSKeyedArchiver.archivedData(withRootObject: podcasts, requiringSecureCoding: false)
			UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
		}catch{
			print("deleting podcast:",error)
		}
		
	}
}
