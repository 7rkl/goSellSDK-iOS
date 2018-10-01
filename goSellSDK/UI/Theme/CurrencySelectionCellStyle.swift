//
//  CurrencySelectionCellStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct CurrencySelectionCellStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let billIcon: ResourceImage
	internal let transactionCurrencyTextStyle: TextStyle
	internal let selectedCurrencyTextStyle: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case billIcon 						= "icon"
		case transactionCurrencyTextStyle	= "transaction_text_style"
		case selectedCurrencyTextStyle 		= "selected_text_style"
	}
}
