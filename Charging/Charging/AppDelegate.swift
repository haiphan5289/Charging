//
//  AppDelegate.swift
//  Charging
//
//  Created by haiphan on 23/07/2021.
//

import UIKit
import Intents

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.setupFlowApp()
        UIFont.overrideInitialize()
        
        ChargeManage.shared.start()
//
//        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
//            if shortcutItem.type == "com.yoursite.yourapp.adduser" {
//                // shortcut was triggered!
//
//            }
//        }
//
//        let icon = UIApplicationShortcutIcon(type: .add)
//        let item = UIApplicationShortcutItem(type: "com.yoursite.yourapp.adduser", localizedTitle: "Add User", localizedSubtitle: "Meet someone new", icon: icon, userInfo: nil)
//        UIApplication.shared.shortcutItems = [item]
//
//        // Add a user activity to the list of suggestions.
//        var suggestions = [INShortcut(userActivity: orderFavoriteBeverageUserActivity)]
//
//        // Add an intent to the list of suggestions. To create
//        // a shortcut from an intent, the intent must be valid.
//        if let shortcut = INShortcut(intent: orderSoupOfTheDayIntent) {
//            suggestions.append(shortcut)
//        }
//
//        // Suggest the shortcuts.
//        INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
        
        return true
    }
    
    func setupFlowApp() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
//        let vc = BaseTabbarViewController()
//        let vc = BaseTabbarViewController()
        let vc = IntroduceAppVC.createVC()
        
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

