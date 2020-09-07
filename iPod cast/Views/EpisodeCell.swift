//
//  EpisodeCell.swift
//  iPod cast
//
//  Created by wiz on 9/6/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
	
	var episode: Episode! {
		didSet {
			descriptionLabel.text = episode.description
			titleLabel.text = episode.title
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, yyyy"
			pubDateLabel.text = dateFormatter.string(from:  episode.pubDate)
			
			let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
			feedImageView.sd_setImage(with: url, completed: nil)
		}
	}
	@IBOutlet weak var feedImageView: UIImageView!
	@IBOutlet weak var pubDateLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel! {
		didSet{
			titleLabel.numberOfLines = 2
		}
	}
	@IBOutlet weak var descriptionLabel: UILabel! {
		didSet{
			descriptionLabel.numberOfLines = 2
		}
	}
	
}
