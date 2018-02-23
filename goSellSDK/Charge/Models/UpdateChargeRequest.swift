//
//  UpdateChargeRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Model to update the charge.
@objcMembers public class UpdateChargeRequest: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Set of key/value pairs that you can attach to an object.
    /// It can be useful for storing additional information about the object in a structured format.
    /// Individual keys can be unset by posting an empty value to them.
    /// All keys can be unset by posting an empty value to metadata.
    /// optional, default is { }
    public var metadata: [String: String]?
    
    /// An arbitrary string which you can attach to a Charge object.
    /// It is displayed when in the web interface alongside the charge.
    public var descriptionText: String?
    
    /// The mobile number to send this charge's receipt to.
    /// The receipt will not be sent until the charge is paid.
    /// If this charge is for a customer, the mobile number specified here will override the customer's mobile number.
    /// Receipts will not be sent for test mode charges.
    /// If receipt_sms is specified for a charge in live mode, a receipt will be sent regardless of your sms settings.
    /// (optional, either receipt_sms or receipt_email is required if customer is not available).
    public var receiptSMS: String?
    
    /// The email address to send this charge's receipt to.
    /// The receipt will not be sent until the charge is paid.
    /// If this charge is for a customer, the email address specified here will override the customer's email address.
    /// Receipts will not be sent for test mode charges.
    /// If receipt_email is specified for a charge in live mode, a receipt will be sent regardless of your email settings.
    /// (optional, either receipt_sms or receipt_email is required if customer is not available)
    public var receiptEmail: String?
    
    // MARK: - Methods -
    
    /// Empty constructor.
    public override init() { super.init() }
    
    /// Creates request to update the charge with metadata, description, receipt SMS and receipt email.
    ///
    /// - Parameters:
    ///   - metadata: Updated metadata.
    ///   - descriptionText: Updated description.
    ///   - receiptSMS: Updated receipt SMS.
    ///   - receiptEmail: Updated receipt email.
    public convenience init(metadata: [String: String]?, descriptionText: String?, receiptSMS: String?, receiptEmail: String?) {
        
        self.init()
        
        self.metadata = metadata
        self.descriptionText = descriptionText
        self.receiptSMS = receiptSMS
        self.receiptEmail = receiptEmail
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case metadata
        case descriptionText = "description"
        case receiptSMS = "receipt_sms"
        case receiptEmail = "receipt_email"
    }
}
