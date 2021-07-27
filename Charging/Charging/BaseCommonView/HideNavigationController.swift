//
//  HideNavigationController.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HideNavigationController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
