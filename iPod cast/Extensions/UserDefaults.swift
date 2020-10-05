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
	static let downloadedEpisodeKey = "downloadedEpisodesKey"
	
	func downloadEpisode(episode: Episode){
		
		do{
			var episodes = downloadEpisodes()
			episodes.insert(episode, at: 0)
			let data = try JSONEncoder().encode(episodes)
			UserDefaults.standard.setValue(data, forKey: UserDefaults.downloadedEpisodeKey)
			
		}catch{
			print("Failed to encode episode:",error)
		}
	}
	
	func downloadEpisodes() -> [Episode] {
		
		do{
			guard let episodeData = data(forKey: UserDefaults.downloadedEpisodeKey) else {return []}
			let episodes = try JSONDecoder().decode([Episode].self, from: episodeData)
			
			return episodes
		}catch{
			print("Failed to decode:",error)
		}
		
		return []
	}
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
	
	func deleteEpisode(episodes: [Episode]) {
		
		do{
			let data = try JSONEncoder().encode(episodes)
			UserDefaults.standard.setValue(data, forKey: UserDefaults.downloadedEpisodeKey)
		}catch{
			print("deleting episode:",error)
		}
		
	}
	
	
}
