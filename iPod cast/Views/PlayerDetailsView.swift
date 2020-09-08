//
//  PlayerDetailsView.swift
//  iPod cast
//
//  Created by wiz on 9/7/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class PlayerDetailsView: UIView {
	
	var episode: Episode! {
		didSet {
			episodeTitleLabel.text = episode.title
			authorLabel.text = episode.author
			
			guard let url = URL(string: episode.imageUrl ?? "") else {return }
			episodeImageView.sd_setImage(with: url, completed: nil)
		}
	}
	
	@IBOutlet weak var episodeImageView: UIImageView!
	@IBOutlet weak var episodeTitleLabel: UILabel! {
		
		didSet {
			episodeTitleLabel.numberOfLines = 0
		}
	}
	@IBOutlet weak var authorLabel: UILabel!
	
	@IBOutlet weak var playPauseTapped: UIButton!
	@IBAction func dismissTapped(_ sender: Any) {
		self.removeFromSuperview()
	}
}
