//
//  favouritePodcastCell.swift
//  iPod cast
//
//  Created by wiz on 9/28/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class favouritePodcastCell: UICollectionViewCell {
	
	let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
	let nameLabel = UILabel()
	let artistNameLabel = UILabel()
	
	fileprivate func stylizeUI() {
		nameLabel.text = "Podcast Namne"
		nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		artistNameLabel.text = "Wiz"
		artistNameLabel.font = UIFont.systemFont(ofSize: 14)
		artistNameLabel.textColor = .lightGray
	}
	
	fileprivate func setupViews() {
		imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
		
		let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel,artistNameLabel])
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)
		
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		stylizeUI()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
