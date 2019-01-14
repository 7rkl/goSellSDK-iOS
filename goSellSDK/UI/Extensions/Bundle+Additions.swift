//
//  Bundle+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Bundle {
    
    internal static let goSellSDKResources: Bundle = {
        
        guard let result = Bundle(for: PaymentContentViewController.self).childBundle(named: Constants.goSellSDKResourcesBundleName) else {
            
            fatalError("There is no \(Constants.goSellSDKResourcesBundleName) bundle.")
        }
        
        return result
    }()
    
    private struct Constants {
        
        fileprivate static let goSellSDKResourcesBundleName = "goSellSDKResources"
        
        @available(*, unavailable) private init() {}
    }
}
