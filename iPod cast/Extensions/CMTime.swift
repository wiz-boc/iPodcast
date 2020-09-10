//
//  CMTime.swift
//  iPod cast
//
//  Created by wiz on 9/9/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import AVKit

extension CMTime {
	
	func toDisplayString() -> String {
		
		let rawSeconds = CMTimeGetSeconds(self)
		guard !(rawSeconds.isNaN || rawSeconds.isInfinite) else {
			return "--:--" // or some other default string
		}
		
		let totalSeconds = Int(rawSeconds)
		let seconds = totalSeconds % 60
		let minutes = totalSeconds / 60
		let timeFormatString = String(format: "%02d:%02d", minutes,seconds)
		
		return timeFormatString
	}
}
