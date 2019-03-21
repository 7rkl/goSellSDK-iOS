//
//  Process.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias
import enum		TapVisualEffectView.TapBlurEffectStyle
import class	UIKit.UIImage.UIImage

/// Process class.
internal final class Process {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal private(set) var transactionMode:	TransactionMode	= .default
	internal private(set) var appearance:		AppearanceMode	= .fullscreen
	
	internal private(set) var externalSession: SessionProtocol?
	
	internal var wrappedImplementation: Wrapped {
		
		if let existing = self.wrapped {
			
			if let _: Process.Implementation<PaymentClass> = existing.implementation(), (self.transactionMode == .purchase || self.transactionMode == .authorizeCapture) {
				
				return existing
			}
			else if let _: Process.Implementation<CardSavingClass> = existing.implementation(), self.transactionMode == .cardSaving {
				
				return existing
			}
			else if let _: Process.Implementation<CardTokenizationClass> = existing.implementation(), self.transactionMode == .cardTokenization {
				
				return existing
			}
		}
		
		switch self.transactionMode {
			
		case .purchase, .authorizeCapture:
			
			let impl = Implementation<PaymentClass>.with(process: self, mode: PaymentClass.self)
			let w = Wrapped(impl)
			
			self.wrapped = w
			
			return w
			
		case .cardSaving:
			
			let impl = Implementation<CardSavingClass>.with(process: self, mode: CardSavingClass.self)
			let w = Wrapped(impl)
			
			self.wrapped = w
			
			return w
			
		case .cardTokenization:
			
			let impl = Implementation<CardTokenizationClass>.with(process: self, mode: CardTokenizationClass.self)
			let w = Wrapped(impl)
			
			self.wrapped = w
			
			return w
		}
	}
	
	// MARK: Methods
	
	internal static func paymentClosed() {
		
		KnownStaticallyDestroyableTypes.destroyAllInstances()
	}
	
	@discardableResult internal func start(_ session: SessionProtocol) -> Bool {
		
		self.transactionMode	= session.dataSource?.mode ?? .default
		self.appearance			= self.obtainAppearanceMode(from: session)
		
		let result = self.dataManagerInterface.loadPaymentOptions(for: session)
		
		if result {
			
			self.externalSession = session
			self.customizeAppearance(for: session)
		}
		
		return result
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private static var storage: Process?
	
	private var wrapped: Wrapped?
	
	// MARK: Methods
	
	private init() {
		
		KnownStaticallyDestroyableTypes.add(Process.self)
	}
	
	private func obtainAppearanceMode(from session: SessionProtocol) -> AppearanceMode {
		
		let publicAppearance = session.appearance?.appearanceMode?(for: session) ?? .default
		let transactionMode = session.dataSource?.mode ?? .default
		
		let result = AppearanceMode(publicAppearance: publicAppearance, transactionMode: transactionMode)
		
		return result
	}
	
	private func customizeAppearance(for session: SessionProtocol) {
		
		ThemeManager.shared.resetCurrentThemeToDefault()
		
		let externalAppearance = self.externalSession?.appearance
		
		var commonStyle = Theme.current.commonStyle
		if let backgroundColor = externalAppearance?.backgroundColor?(for: session) {
			
			let color = backgroundColor.tap_asHexColor
			
			commonStyle.backgroundColor[.fullscreen]	= color
			commonStyle.backgroundColor[.windowed]		= color
		}
		
		if let contentBackgroundColor = externalAppearance?.contentBackgroundColor?(for: session) {
			
			let color = contentBackgroundColor.tap_asHexColor
			
			commonStyle.contentBackgroundColor[.fullscreen]	= color
			commonStyle.contentBackgroundColor[.windowed]	= color
		}
		
		if let blurStyle = externalAppearance?.backgroundBlurEffectStyle?(for: session) {
			
			let tapBlurStyle = blurStyle.effectStyle
			
			commonStyle.blurStyle[.fullscreen].style	= tapBlurStyle
			commonStyle.blurStyle[.windowed].style		= tapBlurStyle
		}
		
		if #available(iOS 10.0, *) {
			
			if let blurProgress = externalAppearance?.backgroundBlurProgress?(for: session) {
				
				commonStyle.blurStyle[.fullscreen].progress	= blurProgress
				commonStyle.blurStyle[.windowed].progress	= blurProgress
			}
		}
		
		Theme.current.commonStyle = commonStyle
		
		var headerStyle = Theme.current.merchantHeaderStyle
		
		if let headerFont = externalAppearance?.headerFont?(for: session) {
			
			let font = Font(headerFont)
			headerStyle.titleStyle.font = font
		}
		
		if let headerTextColor = externalAppearance?.headerTextColor?(for: session) {
			
			headerStyle.titleStyle.color = headerTextColor.tap_asHexColor
		}
		
		if let headerBackgroundColor = externalAppearance?.headerBackgroundColor?(for: session) {
			
			headerStyle.backgroundColor = headerBackgroundColor.tap_asHexColor
		}
		
		if let cancelButtonFont = externalAppearance?.headerCancelButtonFont?(for: session) {
			
			let font = Font(cancelButtonFont)
			headerStyle.cancelNormalStyle.font		= font
			headerStyle.cancelHighlightedStyle.font	= font
		}
		
		if let cancelNormalColor = externalAppearance?.headerCancelButtonTextColor?(for: .normal, session: session) {
			
			headerStyle.cancelNormalStyle.color = cancelNormalColor.tap_asHexColor
		}
		
		if let cancelHighlightedColor = externalAppearance?.headerCancelButtonTextColor?(for: .highlighted, session: session) {
			
			headerStyle.cancelHighlightedStyle.color = cancelHighlightedColor.tap_asHexColor
		}
		
		Theme.current.merchantHeaderStyle = headerStyle
		
		var cardInputTextStyle = Theme.current.paymentOptionsCellStyle.card.textInput
		
		if let cardInputFont = externalAppearance?.cardInputFieldsFont?(for: session) {
		
			let font = Font(cardInputFont)
			
			cardInputTextStyle[.valid].font			= font
			cardInputTextStyle[.invalid].font		= font
			cardInputTextStyle[.placeholder].font	= font
		}
		
		if let validCardInputColor = externalAppearance?.cardInputFieldsTextColor?(for: session) {
			
			cardInputTextStyle[.valid].color = validCardInputColor.tap_asHexColor
		}
		
		if let invalidCardInputColor = externalAppearance?.cardInputFieldsInvalidTextColor?(for: session) {
			
			cardInputTextStyle[.invalid].color = invalidCardInputColor.tap_asHexColor
		}
		
		if let placeholderCardInputColor = externalAppearance?.cardInputFieldsPlaceholderColor?(for: session) {
			
			cardInputTextStyle[.placeholder].color = placeholderCardInputColor.tap_asHexColor
		}
		
		Theme.current.paymentOptionsCellStyle.card.textInput = cardInputTextStyle
		
		var cardInputStyle = Theme.current.paymentOptionsCellStyle.card
		
		if let cardInputDescriptionFont = externalAppearance?.cardInputDescriptionFont?(for: session) {
			
			cardInputStyle.saveCard.textStyle.font = Font(cardInputDescriptionFont)
		}
		
		if let cardInputDescriptionColor = externalAppearance?.cardInputDescriptionTextColor?(for: session) {
			
			cardInputStyle.saveCard.textStyle.color = cardInputDescriptionColor.tap_asHexColor
		}
		
		if let saveCardSwitchOffTintColor = externalAppearance?.cardInputSaveCardSwitchOffTintColor?(for: session) {
			
			cardInputStyle.saveCard.switchOffTintColor = saveCardSwitchOffTintColor.tap_asHexColor
		}
		
		if let saveCardSwitchOnTintColor = externalAppearance?.cardInputSaveCardSwitchOnTintColor?(for: session) {
			
			cardInputStyle.saveCard.switchOnTintColor = saveCardSwitchOnTintColor.tap_asHexColor
		}
		
		if let saveCardSwitchThumbTintColor = externalAppearance?.cardInputSaveCardSwitchThumbTintColor?(for: session) {
			
			cardInputStyle.saveCard.switchThumbTintColor = saveCardSwitchThumbTintColor.tap_asHexColor
		}
		
		if	let scanIconFrameTintColor = externalAppearance?.cardInputScanIconFrameTintColor?(for: session),
			let tinted = cardInputStyle.scanIconFrame.tap_byApplyingTint(color: scanIconFrameTintColor) {
			
			cardInputStyle.scanIconFrame = tinted.tap_asResourceImage
		}
		
		if	let scanIconIconTintColor = externalAppearance?.cardInputScanIconTintColor?(for: session),
			let tinted = cardInputStyle.scanIconIcon.tap_byApplyingTint(color: scanIconIconTintColor) {
			
			cardInputStyle.scanIconIcon = tinted.tap_asResourceImage
		}
		
		cardInputStyle.scanIcon = UIImage(tap_byCombining: [cardInputStyle.scanIconFrame, cardInputStyle.scanIconIcon])
		
		Theme.current.paymentOptionsCellStyle.card = cardInputStyle
		
		var buttonStyles = Theme.current.buttonStyles
		
		if let buttonDisabledBackgroundColor = externalAppearance?.tapButtonBackgroundColor?(for: .disabled, session: session) {
			
			let hexColor = buttonDisabledBackgroundColor.tap_asHexColor
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].disabled.backgroundColor = hexColor
			}
		}
		
		if let buttonEnabledBackgroundColor = externalAppearance?.tapButtonBackgroundColor?(for: .normal, session: session) {
			
			let hexColor = buttonEnabledBackgroundColor.tap_asHexColor
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].enabled.backgroundColor = hexColor
			}
		}
		
		if let buttonHighlightedBackgroundColor = externalAppearance?.tapButtonBackgroundColor?(for: .highlighted, session: session) {
			
			let hexColor = buttonHighlightedBackgroundColor.tap_asHexColor
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].highlighted.backgroundColor = hexColor
			}
		}
		
		if let buttonFont = externalAppearance?.tapButtonFont?(for: session) {
			
			let font = Font(buttonFont)
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].disabled.titleStyle.font	= font
				buttonStyles[index].enabled.titleStyle.font		= font
				buttonStyles[index].highlighted.titleStyle.font	= font
			}
		}
		
		if let buttonDisabledTextColor = externalAppearance?.tapButtonTextColor?(for: .disabled, session: session) {
			
			let hexColor = buttonDisabledTextColor.tap_asHexColor
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].disabled.titleStyle.color = hexColor
			}
		}
		
		if let buttonEnabledTextColor = externalAppearance?.tapButtonTextColor?(for: .normal, session: session) {
			
			let hexColor = buttonEnabledTextColor.tap_asHexColor
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].enabled.titleStyle.color = hexColor
			}
		}
		
		if let buttonHighlightedTextColor = externalAppearance?.tapButtonTextColor?(for: .highlighted, session: session) {
			
			let hexColor = buttonHighlightedTextColor.tap_asHexColor
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].highlighted.titleStyle.color = hexColor
			}
		}
		
		if let buttonCornerRadius = externalAppearance?.tapButtonCornerRadius?(for: session) {
			
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].disabled.cornerRadius		= buttonCornerRadius
				buttonStyles[index].enabled.cornerRadius		= buttonCornerRadius
				buttonStyles[index].highlighted.cornerRadius	= buttonCornerRadius
			}
		}
		
		if let buttonLoaderVisible = externalAppearance?.isLoaderVisibleOnTapButtton?(for: session) {
			
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].disabled.isLoaderVisible	= buttonLoaderVisible
				buttonStyles[index].enabled.isLoaderVisible		= buttonLoaderVisible
				buttonStyles[index].highlighted.isLoaderVisible	= buttonLoaderVisible
			}
		}
		
		if let securityIconVisible = externalAppearance?.isSecurityIconVisibleOnTapButton?(for: session) {
			
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].disabled.isSecurityIconVisible		= securityIconVisible
				buttonStyles[index].enabled.isSecurityIconVisible		= securityIconVisible
				buttonStyles[index].highlighted.isSecurityIconVisible	= securityIconVisible
			}
		}
		
		if let buttonInsets = externalAppearance?.tapButtonInsets?(for: session) {
			
			let tapInsets = TapEdgeInsets(buttonInsets)
			
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].disabled.insets 	= tapInsets
				buttonStyles[index].enabled.insets		= tapInsets
				buttonStyles[index].highlighted.insets	= tapInsets
			}
 		}
		
		if let buttonHeight = externalAppearance?.tapButtonHeight?(for: session) {
			
			for (index, _) in buttonStyles.enumerated() {
				
				buttonStyles[index].disabled.height 	= buttonHeight
				buttonStyles[index].enabled.height		= buttonHeight
				buttonStyles[index].highlighted.height	= buttonHeight
			}
		}
		
		Theme.current.buttonStyles = buttonStyles
	}
}

// MARK: - ImmediatelyDestroyable
extension Process: ImmediatelyDestroyable {
	
	internal static var hasAliveInstance: Bool {
		
		return self.storage != nil
	}
	
	internal static func destroyInstance() {
		
		self.storage = nil
	}
}

// MARK: - Singleton
extension Process: Singleton {
	
	internal static var shared: Process {
		
		if let nonnullStorage = self.storage {
			
			return nonnullStorage
		}
		
		let instance = Process()
		self.storage = instance
		
		return instance
	}
}
