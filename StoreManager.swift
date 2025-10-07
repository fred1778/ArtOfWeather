//
//  StoreManager.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 16/01/2021.
//

import Foundation
import SwiftUI
import StoreKit



class AppStoreObserver : NSObject, SKPaymentTransactionObserver, ObservableObject, SKProductsRequestDelegate{

    
    @AppStorage("premium") var premiumEnabled = false
    @Published var didMoveToPremium = false
    @Published var error = false
    @Published var error_str = ""
    @Published var price_str = ""
    
    override init() {

        super.init()

        SKPaymentQueue.default().add(self)


    }
    
    
      let product_id = "aow.iap"
    let confID = "iap_config"
    var request : SKProductsRequest!
    
    func validate(){
        print("store validation request")
        let prod_arr = [product_id]
        let prod_set = Set(prod_arr)
        request = SKProductsRequest(productIdentifiers: prod_set)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        
        print("product req")
       let prods =  response.products
        
        print(prods)
        for p in prods{
            print("PRICE CHECK")
            print(p.price)
            print(p.priceLocale)
            self.price_str = p.priceLocale.currencySymbol! + p.price.stringValue
        }
    }

    
    
      func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("TX UPDATE")
        
        for tx in transactions{
            
            print(tx.description)
            
            
            if tx.transactionState == .purchased{
                print("payment succesful")
                SKPaymentQueue.default().finishTransaction(tx)
                premiumEnabled = true
                didMoveToPremium = true
                
            } else if tx.transactionState == .failed{
                print("tx fail")
                print(tx.error?.localizedDescription)
                self.error = true
            } else if tx.transactionState == .restored{
                print("tx restored")
                premiumEnabled = true
                didMoveToPremium = true

            }
        }
        
        
    }
    
    func restoreTry(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func purchaseTry(){
        
        if !premiumEnabled{
        if SKPaymentQueue.canMakePayments(){
            print("payments permitted, adding req")
            
            let paymentReq = SKMutablePayment()
            paymentReq.productIdentifier = product_id
            SKPaymentQueue.default().add(paymentReq)
            
            
            
            
            
        }  else {
            print("payments not permitted")
        }
        
        
        } else {
            print("already have premium")
        }
    
    }
    
    
    
}
