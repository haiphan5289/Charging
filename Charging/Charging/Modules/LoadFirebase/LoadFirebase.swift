//
//  LoadFirebase.swift
//  Charging
//
//  Created by haiphan on 05/08/2021.
//

import UIKit

class LoadFirebase: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManage.share.fetchCloudValues { isPrenium in
            DispatchQueue.main.async {
                if isPrenium {
                    let vc = BaseTabbarViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = IntroduceAppVC.createVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
}
