//
//  AmountedCurrency.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Structure holding currency and the amount.
internal struct AmountedCurrency: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Currency.
    internal let currency: Currency
    
    /// Amount.
    internal let amount: Decimal
    
    /// Currency symbol.
    internal let currencySymbol: String
    
    /// Conversion factor to transaction currency
    internal var conversionFactor: Decimal{
        get{
            return amount/Process.shared.dataManagerInterface.transactionCurrency.amount
        }
    }
    
    // MARK: Methods
    
    internal init(_ currency: Currency, _ amount: Decimal) {
        
        let symbol = CurrencyFormatter.shared.localizedCurrencySymbol(for: currency.isoCode)
        self.init(currency, amount, symbol)
    }
    
    internal init(_ currency: Currency, _ amount: Decimal, _ currencySymbol: String) {
        
        self.currency       = currency
        self.amount         = amount
        self.currencySymbol = currencySymbol
    }
    
    
    
    func calculateConvrsionRate()
    {
        //
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case currency       = "currency"
        case amount         = "amount"
        case currencySymbol = "symbol"
    }
}

// MARK: - Equatable
extension AmountedCurrency: Equatable {
    
    internal static func == (lhs: AmountedCurrency, rhs: AmountedCurrency) -> Bool {
        
        return lhs.currency == rhs.currency && lhs.amount == rhs.amount
    }
}
