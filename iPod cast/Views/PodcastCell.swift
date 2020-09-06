//
//  PodcastCell.swift
//  iPod cast
//
//  Created by wiz on 9/5/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
	
	@IBOutlet weak var podcastImageView: UIImageView!
	@IBOutlet weak var trackNameLabel: UILabel!
	@IBOutlet weak var artistNameLabel: UILabel!
	@IBOutlet weak var episodeCountLabel: UILabel!
	
	var podcast: Podcast! {
		didSet {
			trackNameLabel.text = podcast.trackName
			artistNameLabel.text = podcast.artistName
			episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episode(s)"
			
			guard let url = URL(string: podcast.artworkUrl600 ?? "") else {
				return
			}
			
//			URLSession.shared.dataTask(with: url) { (data, _, _) in
//
//				guard let data = data else {
//					return
//				}
//				print("Finishing downloading image data:", data)
//				DispatchQueue.main.async {
//					self.podcastImageView.image = UIImage(data: data)
//				}
//
//			}.resume()
			
			podcastImageView.sd_setImage(with: url, completed: nil)
		}
	}
}
