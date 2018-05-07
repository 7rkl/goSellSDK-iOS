//
//  CardValidatorDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol CardValidatorDelegate: ClassProtocol {
    
    func validationStateChanged(to valid: Bool, on type: ValidationType)
}
