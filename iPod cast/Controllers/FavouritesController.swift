//
//  FavouritesController.swift
//  iPod cast
//
//  Created by wiz on 9/27/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class FavouritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	
	fileprivate let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
	}
	
	fileprivate func setupCollectionView(){
		collectionView.backgroundColor = .white
		collectionView.register(favouritePodcastCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	//MARK:- UICollectionView Delegate / Spacing methods
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let width = (view.frame.width - 3 * 16) / 2
		return CGSize(width: width, height: width + 46)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 16
	}
}
