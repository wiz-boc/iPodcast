//
//  UIApplication.swift
//  iPod cast
//
//  Created by wiz on 9/25/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

extension UIApplication {
	
	static func mainTabBarController() -> MainTabBarController? {
		return shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? MainTabBarController
	}
	
}
