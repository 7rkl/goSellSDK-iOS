//
//  UIButton+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapAdditionsKit.UIButton

internal extension UIButton {
	
	internal func setTitleStyle(_ style: TextStyle) {
		
		self.titleLabel?.font 			= style.font.localized
		self.titleLabel?.textAlignment	= style.alignment.textAlignment
		self.titleLabel?.textColor 		= style.color
	}
}

// MARK: - SingleLocalizable
extension UIButton: SingleLocalizable {
	
	internal func setLocalized(text: String?) {
		
		self.tap_title = text
	}
}
