//
//  Localizable.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey

internal enum SingleLocalizableElement { case `default` }

internal protocol Localizable {
	
	associatedtype LocalizableElement
	
	func setLocalized(text: String?, for element: LocalizableElement)
}

internal protocol SingleLocalizable: Localizable where LocalizableElement == SingleLocalizableElement {
	
	func setLocalized(text: String?)
}

internal extension SingleLocalizable {
	
	internal func setLocalized(text: String?, for element: SingleLocalizableElement) {
		
		self.setLocalized(text: text)
	}
}

internal extension Localizable {
	
	internal func setLocalizedText(for element: LocalizableElement, key: LocalizationKey?) {
		
		guard let nonnullKey = key else {
			
			self.setLocalized(text: nil, for: element)
			return
		}
		
		let text = LocalizationManager.shared.localizedString(for: nonnullKey)
		self.setLocalized(text: text, for: element)
	}
	
	internal func setLocalizedText(for element: LocalizableElement, key: LocalizationKey?, _ arguments: CVarArg...) {
		
		self.setLocalizedText(for: element, key: key, arguments: arguments)
	}
	
	internal func setLocalizedText(for element: LocalizableElement, key: LocalizationKey?, arguments: [CVarArg]) {
		
		guard let nonnullKey = key else {
			
			self.setLocalized(text: nil, for: element)
			return
		}
		
		let text = String(format: LocalizationManager.shared.localizedString(for: nonnullKey), arguments: arguments)
		self.setLocalized(text: text, for: element)
	}
}

internal extension Localizable where LocalizableElement == SingleLocalizableElement {
	
	internal func setLocalizedText(_ key: LocalizationKey?) {
		
		self.setLocalizedText(for: .default, key: key)
	}
	
	internal func setLocalizedText(_ key: LocalizationKey?, _ arguments: CVarArg...) {
		
		self.setLocalizedText(for: .default, key: key, arguments: arguments)
	}
}
