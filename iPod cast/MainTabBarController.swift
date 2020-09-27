//
//  MainTabBarController.swift
//  iPod cast
//
//  Created by wiz on 9/2/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit


var maximizedTopAnchorConstraint: NSLayoutConstraint!
var minimizedTopAnchorConstraint: NSLayoutConstraint!
var bottomAnchorConstraint: NSLayoutConstraint!

class MainTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UINavigationBar.appearance().prefersLargeTitles = true
		tabBar.tintColor = .purple
		setupViewControllers()
		setupPlayerDetailsView()
		//perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1)
	}
	
	@objc func minimizePlayerDetails(){
		maximizedTopAnchorConstraint.isActive = false
		bottomAnchorConstraint.constant = view.frame.height
		minimizedTopAnchorConstraint.isActive = true
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
			self.view.layoutIfNeeded()
			self.tabBar.transform = .identity
			//self.tabBar.frame.origin.y -= 100
			//self.tabBar.transform = CGAffineTransform(translationX: 0, y: -100)
			self.playerDetailsView.maximizedStackView.alpha = 0
			self.playerDetailsView.miniPlayerView.alpha = 1
		})
	}
	
	func maximizePlayerDetails(episode: Episode?, playlistEpisodes: [Episode] = []){
		minimizedTopAnchorConstraint.isActive = false
		maximizedTopAnchorConstraint.isActive = true
		maximizedTopAnchorConstraint.constant = 0
		
		bottomAnchorConstraint.constant = 0
		if episode != nil {
			playerDetailsView.episode = episode
		}
		
		playerDetailsView.playlistEpisodes = playlistEpisodes
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
			self.view.layoutIfNeeded()
			//self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
			self.tabBar.frame.origin.y += 100
			self.playerDetailsView.maximizedStackView.alpha = 1
			self.playerDetailsView.miniPlayerView.alpha = 0
		})
	}
	
	//MARK:- Setip functions
	let playerDetailsView = PlayerDetailsView.initFromNib()
	
	private func setupPlayerDetailsView(){
		print("Setting up PlayerDetailsView")
		
		
		//use auto layout
		
		//view.addSubview(playerDetailsView)
		view.insertSubview(playerDetailsView, belowSubview: tabBar)
		
		playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
		
		maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
		
		maximizedTopAnchorConstraint.isActive = true
		
		bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
		bottomAnchorConstraint.isActive = true
		
		minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
		//minimizedTopAnchorConstraint.isActive = true
		
		
		playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
	}
	
	
	func setupViewControllers(){
		viewControllers = [
			generateNavigationController(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
			generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
			generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
		]
	}
	
	//MARK:- Helpler functions
	fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage)-> UIViewController{
		
		let navController = UINavigationController(rootViewController: rootViewController)
		rootViewController.navigationItem.title = title
		navController.tabBarItem.title = title
		navController.tabBarItem.image = image
		
		return navController
	}
	
}

