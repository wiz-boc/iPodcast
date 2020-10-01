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
	
	var podcasts = UserDefaults.standard.savedPodcasts()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
	}
	
	fileprivate func setupCollectionView(){
		collectionView.backgroundColor = .white
		collectionView.register(favouritePodcastCell.self, forCellWithReuseIdentifier: cellId)
		
		let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
		collectionView.addGestureRecognizer(gesture)
	}
	
	@objc func handleLongPress(gesture: UILongPressGestureRecognizer){
		let location = gesture.location(in: collectionView)
		guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { return }
		
		
		let alertController = UIAlertController(title: "Remove Podcast? ", message: nil, preferredStyle: .actionSheet)
		
		alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
			//where remove the podcast object from collection view
			//let selectedPodcast = self.podcasts[selectedIndexPath.item]
			self.podcasts.remove(at: selectedIndexPath.item)
			self.collectionView.deleteItems(at: [selectedIndexPath])
			
			
			UserDefaults.standard.deletePodcast(podcasts: self.podcasts)
			//remove
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
	
	//MARK:- UICollectionView Delegate / Spacing methods
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return podcasts.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? favouritePodcastCell else { fatalError("Something went wrong with the favoruite podcast cell") }
		cell.podcast = podcasts[indexPath.item]
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
