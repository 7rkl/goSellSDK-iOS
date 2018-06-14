//
//  SourceObject.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum SourceObject: String, Codable {
    
    case card   = "CARD"
    case token  = "TOKEN"
    case source = "SOURCE"
}
