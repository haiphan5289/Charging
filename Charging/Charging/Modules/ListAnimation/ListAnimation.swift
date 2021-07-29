//
//  ListAnimation.swift
//  Charging
//
//  Created by haiphan on 29/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class ListAnimation: BaseNavigationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }

}
extension ListAnimation {
    
    private func setupUI() {
        titleLarge = L10n.hotAnimation
    }
    
    private func setupRX() {
        
    }
    
}
