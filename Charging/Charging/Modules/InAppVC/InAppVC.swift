//
//  InAppVC.swift
//  Charging
//
//  Created by haiphan on 07/08/2021.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyStoreKit
import SVProgressHUD

class InAppVC: UIViewController {
    
    struct SKProductModel {
        let productID: ProductID
        let price: NSDecimalNumber
        init(productID: ProductID, price: NSDecimalNumber) {
            self.productID = productID
            self.price = price
        }
    }

    @IBOutlet weak var btContinue: UIButton!
    @IBOutlet weak var btDismiss: UIButton!
    private let fullAccess: FullAccessView = FullAccessView.loadXib()
    private var statePrenium: FullAccessView.Prenium = .week
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }

}
extension InAppVC {
    
    private func setupUI() {
        self.btContinue.applyGradient(withColours: [Asset._0090Ff.color, Asset._00D3Ff.color], gradientOrientation: .horizontal)
        self.view.addSubview(self.fullAccess)
        self.fullAccess.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.btContinue.snp.top)
        }
        self.fullAccess.hideViewMore()
        self.fullAccess.tapStatePrenium = { stt in
            self.statePrenium = stt
        }
        self.view.bringSubviewToFront(self.btDismiss)
    }
    
    private func setupRX() {
        self.btContinue.rx.tap.bind { _ in
            LoadingManager.instance.show()
            switch self.statePrenium {
            case .week:
                self.weekly()
            case .month:
                self.monthly()
            case .year:
                self.yearly()
            }
        }.disposed(by: disposeBag)
        
        self.btDismiss.rx.tap.bind { _ in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        SHARE_APPLICATION_DELEGATE.inappManager.requestProducts { isSuccess, skProducts in
            var list: [SKProductModel] = []
            if isSuccess, let sk = skProducts, sk.count > 0 {
                sk.forEach { item in
                    guard let type = ProductID(rawValue: item.productIdentifier) else { return }
                    let m = SKProductModel(productID: type, price: item.price)
                    list.append(m)
                }
            }
            let listR = (list.count > 0) ? list : ChargeManage.shared.listRawSKProduct()
            self.fullAccess.loadSKProduct(list: listR)
            
            
        }
        SHARE_APPLICATION_DELEGATE.inappManager.completionHandler = { isSuccess, skProducts in
            var list: [SKProductModel] = []
            if isSuccess, let sk = skProducts, sk.count > 0 {
                sk.forEach { item in
                    guard let type = ProductID(rawValue: item.productIdentifier) else { return }
                    let m = SKProductModel(productID: type, price: item.price)
                    list.append(m)
                }
            }
            let listR = (list.count > 0) ? list : ChargeManage.shared.listRawSKProduct()
            self.fullAccess.loadSKProduct(list: listR)
        }
    }
    
}
extension InAppVC {
    
    //Action restore
    @objc func restoreInApp() {
        if (SHARE_APPLICATION_DELEGATE.inappManager.canMakePurchase()) {
            SHARE_APPLICATION_DELEGATE.inappManager.restoreCompletedTransactions()
        }
    }
    
    //Action 3 nút sẽ call
    func weekly() {
        self.sub(.weekly)
    }
    
    func monthly() {
        self.sub(.monthly)
    }
    
    func yearly() {
        self.sub(.yearly)
    }
    
    func dayfree() {
        self.sub(.dayfree)
    }
    
    func sub(_ model: ProductID) {
        self.subscriptionAction(productId: model.rawValue)
    }
    
    func subscriptionAction(productId: String) {
        //self.showLoading()
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { [weak self] (result) in
            guard let `self` = self else { return }
            //self.hideLoading()
            switch result {
            case .success(_):
                LoadingManager.instance.dismiss()
                Configuration.joinPremiumUser(join: true)
                self.showAlert(title: "Successful", message: "Successful") { [weak self] in
                    self?.dismiss(animated: true, completion: { [weak self] in
                        //self?.delegate?.didFinishJoinPremium()
                    })
                }
            case .error(_):
                LoadingManager.instance.dismiss()
                self.showAlert(title: "Cannot subcribe", message: "Cannot subcribe")
                break
            }
        }
        
    }
}
