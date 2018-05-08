//
//  DataValidation.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class UIKit.UITextField.UITextField

/// Data validation protocol.
internal protocol DataValidation: ClassProtocol {
    
    var validationType: ValidationType { get }
    
    var isDataValid: Bool { get }
    
    func validate()
}

internal protocol TextInputDataValidation: DataValidation {
    
    var textInputField: UITextField { get }
    
    var textInputFieldText: String { get }
    var textInputFieldPlaceholderText: String { get }
    
    func updateSpecificInputFieldAttributes()
}

internal extension TextInputDataValidation {
    
    internal func updateInputFieldAttributes() {
        
        let cardInputSettings = Theme.current.settings.cardInputFieldsSettings
        let textSettings = self.isDataValid || self.textInputField.isEditing ? cardInputSettings.valid : cardInputSettings.invalid
        let textAttributes = textSettings.asStringAttributes
        
        self.textInputField.defaultTextAttributes = textAttributes.mapKeys { $0.rawValue }
        
        let selectedRange = self.textInputField.selectedTextRange
        self.textInputField.attributedText = NSAttributedString(string: self.textInputFieldText, attributes: textAttributes)
        self.textInputField.selectedTextRange = selectedRange
        
        let placeholderAttributes = cardInputSettings.placeholder.asStringAttributes
        self.textInputField.attributedPlaceholder = NSAttributedString(string: self.textInputFieldPlaceholderText, attributes: placeholderAttributes)
        
        self.updateSpecificInputFieldAttributes()
    }
}
