//
//  String.swift
//  iPod cast
//
//  Created by wiz on 9/6/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import Foundation


extension String{
	
	func toSecureHTTPS() -> String {
		return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
	}
}
