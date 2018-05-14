//
//  CurrencySelectionTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel

/// Cell for currency selection.
internal class CurrencySelectionTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CurrencySelectionTableViewCellViewModel?
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var transactionCurrencyLabel: UILabel?
    @IBOutlet private weak var userSelectedCurrencyLabel: UILabel?
    @IBOutlet private weak var billImageView: UIImageView?
    @IBOutlet private weak var arrowImageView: UIImageView?
}

// MARK: - LoadingWithModelCell
extension CurrencySelectionTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.transactionCurrencyLabel?.text = self.model?.displayedTransactionCurrencyText
        self.userSelectedCurrencyLabel?.text = self.model?.displayedUserCurrencyText
        self.billImageView?.image = self.model?.billImage
        self.arrowImageView?.image = self.model?.arrowImage
    }
}
