//
//  BINResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

/// BIN Response model.
internal struct BINResponse: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card BIN number.
    internal let binNumber: String?
    
    /// Card issuer bank.
    internal let bank: String?
    
    /// Card brand.
    internal let cardBrand: CardBrand?
    
    /// Card issuing country.
    internal let country: Country?
    
    /// Bank logo URL.
    internal let bankLogoURL: URL?
    
    /// Defines if address is required
    internal let isAddressRequired: Bool?
    
    /// Address format.
    internal let addressFormat: [AddressField]?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case binNumber          = "bin"
        case bank               = "bank"
        case cardBrand          = "card_brand"
        case country            = "country_code"
        case bankLogoURL        = "bank_logo"
        case isAddressRequired  = "address_required"
        case addressFormat      = "address_format"
    }
}

// MARK: - Equatable
extension BINResponse: Equatable {
    
    internal static func == (lhs: BINResponse, rhs: BINResponse) -> Bool {
        
        return lhs.binNumber == rhs.binNumber
    }
}
