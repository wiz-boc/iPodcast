//
//  MainTabBarController.swift
//  iPod cast
//
//  Created by wiz on 9/2/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UINavigationBar.appearance().prefersLargeTitles = true
		
		tabBar.tintColor = .purple
		
		setupViewControllers()
	}
	
	//MARK:- Setip functions
	
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

