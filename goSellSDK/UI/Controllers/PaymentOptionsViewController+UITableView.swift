//
//  PaymentOptionsViewController+UITableView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

// MARK: - UIScrollViewDelegate
extension PaymentOptionsViewController: UIScrollViewDelegate {
    
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.view.firstResponder?.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension PaymentOptionsViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PaymentDataManager.shared.paymentOptionCellViewModels.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let model = (PaymentDataManager.shared.paymentOptionCellViewModels.filter { $0.indexPath == indexPath }).first else {
            
            fatalError("Data source is corrupted.")
        }
        
        if let currencyCellModel = model as? CurrencySelectionTableViewCellViewModel {
            
            let cell = currencyCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let emptyCellModel = model as? EmptyTableViewCellModel {
            
            let cell = emptyCellModel.dequeueCell(from: tableView)
            return cell
        }
        if let groupCellModel = model as? GroupTableViewCellModel {
            
            let cell = groupCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let webCellModel = model as? WebPaymentOptionTableViewCellModel {
            
            let cell = webCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let cardCellModel = model as? CardInputTableViewCellModel {
            
            let cell = cardCellModel.dequeueCell(from: tableView)
            cell.bindContent()
            return cell
        }
        else {
            
            fatalError("Unknown cell model: \(model)")
        }
    }
}

// MARK: - UITableViewDelegate
extension PaymentOptionsViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let model = (PaymentDataManager.shared.paymentOptionCellViewModels.filter { $0.indexPath == indexPath }).first else {
            
            fatalError("Data source is corrupted.")
        }
        
        if let currencyModel = model as? CurrencySelectionTableViewCellViewModel {
            
            currencyModel.updateCell()
        }
        else if let groupModel = model as? GroupTableViewCellModel {
            
            groupModel.updateCell()
        }
        else if let webCellModel = model as? WebPaymentOptionTableViewCellModel {
            
            webCellModel.updateCell()
        }
        else if let cardCellModel = model as? CardInputTableViewCellModel {
            
            cardCellModel.updateCell()
        }
    }
    
    internal func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let model = (PaymentDataManager.shared.paymentOptionCellViewModels.filter { $0.indexPath == indexPath }).first else {
            
            fatalError("Data source is corrupted.")
        }
        
        return model.indexPathOfCellToSelect
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let model = (PaymentDataManager.shared.paymentOptionCellViewModels.filter { $0.indexPath == indexPath }).first else {
            
            fatalError("Data source is corrupted.")
        }
        
        model.tableViewDidSelectCell(tableView)
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let model = (PaymentDataManager.shared.paymentOptionCellViewModels.filter { $0.indexPath == indexPath }).first else {
            
            fatalError("Data source is corrupted.")
        }
        
        model.tableViewDidDeselectCell(tableView)
    }
}
