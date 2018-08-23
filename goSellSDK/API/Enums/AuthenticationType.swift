//
//  AuthenticationType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objc public enum AuthenticationType: Int {
    
    case otp
    case biometrics
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .otp:          return "OTP"
        case .biometrics:   return "BIOMETRICS"

        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case AuthenticationType.otp.stringValue:        self = .otp
        case AuthenticationType.biometrics.stringValue: self = .biometrics
            
        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: AuthenticationType.self, value: stringValue)
        }
    }
}

// MARK: - Decodable
extension AuthenticationType: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        try self.init(stringValue)
    }
}

// MARK: - Encodable
extension AuthenticationType: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}
