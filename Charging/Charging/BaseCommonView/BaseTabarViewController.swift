//
//  BaseTabarViewController.swift
//  Ayofa
//
//  Created by Admin on 3/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum TypeTabbar: Int, CaseIterable {
    case animation
//    case library
//    case imported
    
    var image: UIImage? {
        switch self {
        case .animation:
            return UIImage(named: "HomeInActive")
//        case .library:
//            return UIImage(named: "libraryInActive")
//        case .imported:
//            return UIImage(named: "ImportedInActive")
        }
    }
    
    var imageActive: UIImage? {
        switch self {
        case .animation:
            return UIImage(named: "HomeActive")
//        case .library:
//            return UIImage(named: "libraryActive")
//        case .imported:
//            return UIImage(named: "importedActive")
        }
    }
    
}

class BaseTabbarViewController: UITabBarController {
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupVar()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupVar() {
        setupTabbar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var bottomSafeArea: CGFloat = 5

        if #available(iOS 11.0, *) {
            if view.safeAreaInsets.bottom > 0 {
                bottomSafeArea = 10
            }
            
        }
        
        let height: CGFloat = tabBar.frame.height + bottomSafeArea
        var tabFrame            = tabBar.frame
        tabFrame.size.height    = height
        tabFrame.origin.y       = view.frame.size.height - height
        tabBar.frame            = tabFrame
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let listTabbar = self.tabBar.items else {
            return
        }
        
        listTabbar.enumerated().forEach { (tabbar) in
            if let type = TypeTabbar(rawValue: tabbar.offset) {
                if tabbar.element == item {
                    tabbar.element.image = type.imageActive
                } else {
                    tabbar.element.image = type.image
                }
            }
        }
        
    }
    
    func setupUI() {
//        self.tabBar.isTranslucent = false
//        UITabBar.appearance().tintColor = TABBAR_COLOR
    }
    
    func setupTabbar() {
        let animation = Animation(nibName: "Animation", bundle: nil)
//        let nvLibraryVC = BaseNavigationController(rootViewController: libraryVC)
//        let importedVC = ImportedVC.createVC()
        
//        let check = Check.createVC()
//        let check = UIStoryboard(name: "CheckStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "CheckStory") as! CheckStory
        self.viewControllers = [animation]
        
        TypeTabbar.allCases.forEach { (type) in
            if let vc = self.viewControllers?[type.rawValue] {
                switch type {
                case .animation:
                    vc.tabBarItem.image = type.imageActive
                default:
                    vc.tabBarItem.image = type.image
                }
                
//                if type == .home {
////                    vc.tabBarItem.title = "⎯"
//                }
            }
        }
//        //1 mảng vc
//        let nav1 = BaseNavigationController(rootViewController: vc1)
//        let nav2 = BaseNavigationController(rootViewController: vc2)
//        let nav3 = BaseNavigationController(rootViewController: vc3)
//        let nav4 = BaseNavigationController(rootViewController: vc4)
//        let nav5 = BaseNavigationController(rootViewController: vc5)
//        self.viewControllers = [nav1, nav2,nav3, nav4, nav5]
//        
//        var list = RealmManager.shared.getCartProduct()
//        vc3.tabBarItem.badgeValue = (list.count > 0) ? "\(list.count)" : nil
//        NotificationCenter.default.rx
//            .notification(Notification.Name(rawValue: PushNotificationKeys.didUpdateCartProduct.rawValue))
//            .asObservable()
//            .bind { _ in
//                list = RealmManager.shared.getCartProduct()
//                vc3.tabBarItem.badgeValue = (list.count > 0) ? "\(list.count)" : nil
//            }.disposed(by: disposeBag)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Handle didSelect viewController method here
    }
}
