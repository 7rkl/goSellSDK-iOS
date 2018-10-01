//
//  CommonImages.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct CommonImages: Decodable {
	
    // MARK: - Internal -
    // MARK: Properties
	
    internal let arrowRight: ResourceImage
    internal let arrowLeft: ResourceImage
    internal let checkmarkImage: ResourceImage
    internal let closeImage: ResourceImage
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case arrowRight 	= "arrow_right"
		case arrowLeft 		= "arrow_left"
		case checkmarkImage	= "checkmark"
		case closeImage 	= "close"
	}
}
