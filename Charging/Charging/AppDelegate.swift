//
//  AppDelegate.swift
//  Charging
//
//  Created by haiphan on 23/07/2021.
//

import UIKit
import Intents
import Firebase
import StoreKit
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var inappManager = InAppPerchaseManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        FirebaseApp.configure()
        
        UIFont.overrideInitialize()
        
        ChargeManage.shared.start()
        
        
        switch ChargeManage.shared.batteryState {
        case .charging, .full:
            self.setupFlowShortcutsApp()
        default:
            self.setupFlowApp()
        }
        
        return true
    }
    
    func setupFlowApp() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
//        let vc = BaseTabbarViewController()
//        let vc = BaseTabbarViewController()
        let vc = LoadFirebase.createVC()
        
        let navi: UINavigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
    }
    
    func setupFlowShortcutsApp() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
//        let vc = BaseTabbarViewController()
//        let vc = BaseTabbarViewController()
//        let vc = AnimationSelection.createVC()
        let vc = AnimationSelection.createVCfromStoryBoard()
        vc.openfrom = .app
//        vc.autoMove()
        let navi: UINavigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    //MARK: - SETUP IN-APP PURCHASE
    
    
    func setupInAppPurchase() {
        //fetch product
        SwiftyStoreKit.completeTransactions(atomically: true) { (purchases) in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    //Unlock content
                    print("productID " + purchase.productId)
                    
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}
