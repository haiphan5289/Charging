////
////  IAPManager.swift
////  FileManager_iOS
////
////  Created by Admin on 23/07/2021.
////
//
//import Foundation
//import SwiftyStoreKit
//import StoreKit
//import PKHUD
//
//
//public typealias ProductIdentifier = String
//public typealias ProductsRequestCompletionHandler = (_ products: [SKProduct]) -> Void
//public typealias PurchaseSuccess = () -> Void
//
//struct IAPManager  {
//    
//    static let store = IAPManager()
//    
//    static let oneMonth = InAppProductID.monthly.rawValue
//    static let oneYear = InAppProductID.yearly.rawValue
//    
//    private static let productIdentifiers: Set<ProductIdentifier> = [oneMonth, oneYear]
//    
//    func requestPackInfo(completion: @escaping ProductsRequestCompletionHandler){
//        
//        HUD.show(.progress)
//        SwiftyStoreKit.retrieveProductsInfo(IAPManager.productIdentifiers) { result in
//            let products = result.retrievedProducts
//            var productsList:[SKProduct] = []
//            products.forEach { product in
//                productsList.append(product)
//            }
//            HUD.hide()
//            completion(productsList)
//        }
//    }
//    
//    func purchasePack(packNameId:String, completion: @escaping PurchaseSuccess ){
//        HUD.show(.progress)
//        SwiftyStoreKit.purchaseProduct(packNameId, quantity: 1, atomically: true) { result in
//            switch result {
//            case .success( _):
//                HUD.show(.labeledSuccess(title: "Success", subtitle: "Purchase Success"))
//                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                    HUD.hide()
//                }
//                UserConfig.shared.isPremiumUser = true
//                completion()
//            case .error(let error):
//                switch error.code {
//                case .unknown:   HUD.show(.labeledError(title: nil, subtitle: "Unknown error. Please contact support"))
//                case .clientInvalid: HUD.show(.labeledError(title: nil, subtitle: "Not allowed to make the payment"))
//                case .paymentCancelled: HUD.show(.labeledError(title: nil, subtitle: "Payment Cancel"))
//                case .paymentInvalid: HUD.show(.labeledError(title: nil, subtitle: "The purchase identifier was invalid"))
//                case .paymentNotAllowed:
//                    HUD.show(.labeledError(title: nil, subtitle: "The device is not allowed to make the payment"))
//                    
//                case .storeProductNotAvailable:
//                    HUD.show(.labeledError(title: nil, subtitle: "The product is not available in the current storefront"))
//                case .cloudServicePermissionDenied:
//                    HUD.show(.labeledError(title: nil, subtitle: "Access to cloud service information is not allowed"))
//                case .cloudServiceNetworkConnectionFailed:
//                    HUD.show(.labeledError(title: nil, subtitle: "Could not connect to the network"))
//                case .cloudServiceRevoked:
//                    HUD.show(.labeledError(title: nil, subtitle: "User has revoked permission to use this cloud service"))
//                   
//                default:
//                    HUD.show(.labeledError(title: nil, subtitle: "Unknown error. Please contact support"))
//                }
//                
//                
//                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                    HUD.hide()
//                }
//            }
//        }
//    }
//    
//    func restorePurchase(completion: @escaping PurchaseSuccess){
//        HUD.show(.progress)
//        SwiftyStoreKit.restorePurchases(atomically: true) { results in
//            if results.restoreFailedPurchases.count > 0 {
//                
//                HUD.show(.labeledError(title: nil, subtitle: "Restore Fail"))
//                
//                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                    HUD.hide()
//                }
//                UserConfig.shared.isPremiumUser = false
//            }
//            else if results.restoredPurchases.count > 0 {
//                HUD.show(.labeledSuccess(title: "Success", subtitle: "Restore Success"))
//                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                    HUD.hide()
//                }
//                UserConfig.shared.isPremiumUser = true
//                completion()
//            }
//            else {
//                
//                HUD.show(.labeledError(title: nil, subtitle: "Nothing to Restore"))
//                
//                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                    HUD.hide()
//                }
//                UserConfig.shared.isPremiumUser = false
//            }
//        }
//    }
//    
//    func veryPurchase(packNameId: String, completion: @escaping PurchaseSuccess) ->Bool{
//        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: SharedSecrectKey)
//        var isPurchase = false
//        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
//            switch result {
//            case .success(let receipt):
//                // Verify the purchase of Consumable or NonConsumable
//                let purchaseResult = SwiftyStoreKit.verifyPurchase(
//                    productId: packNameId,
//                    inReceipt: receipt)
//                    
//                switch purchaseResult {
//                case .purchased(_):
//                    isPurchase = true
//                    
//                    UserConfig.shared.isPremiumUser = true
//                    
//                case .notPurchased:
//                    
//                   isPurchase = false
//                    UserConfig.shared.isPremiumUser = false
//                }
//                
//                
//            case .error(_):
//               
//                isPurchase = false
//                UserConfig.shared.isPremiumUser = false
//            }
//            
//        }
//        return isPurchase
//    }
//    
//    func veryCheckRegisterPack(){
//        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: SharedSecrectKey)
//        
//        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
//            switch result {
//            case .success(let receipt):
//                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: [IAPManager.oneYear, IAPManager.oneYear], inReceipt: receipt)
//                
//                    
//                switch purchaseResult {
//                case .purchased( _, _):
//                    UserConfig.shared.isPremiumUser = true
//      
//                case .expired(_,_):
//                    
//                    UserConfig.shared.isPremiumUser = false
//                case .notPurchased:
//                    
//                    UserConfig.shared.isPremiumUser = false
//                }
//            case .error(_):
//                UserConfig.shared.isPremiumUser = false
//            }
//        }
//    }
//
//}
