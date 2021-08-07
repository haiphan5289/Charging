//
//  IntroduceAppVC.swift
//  Charging
//
//  Created by haiphan on 31/07/2021.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyStoreKit
import StoreKit
import Firebase
import FirebaseRemoteConfig

class IntroduceAppVC: UIViewController {

    enum StateView {
        case amazing, choosen, fullAccess
    }
    
    enum ActionBottom: Int, CaseIterable {
        case term, restore, privacy
    }
    
    enum StateBack {
        case inApp, home
    }
    
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var vAnimation: UIView!
    @IBOutlet weak var btContinue: UIButton!
    @IBOutlet weak var btContinue2: UIButton!
    @IBOutlet weak var vBottom: UIView!
    @IBOutlet weak var bottomViewStack: NSLayoutConstraint!
    @IBOutlet weak var bottomView: NSLayoutConstraint!
    @IBOutlet var bts: [UIButton]!
    var stataBack: StateBack = .inApp
    private let vAmazing: AmazingView = AmazingView.loadXib()
    private let fullAccess: FullAccessView = FullAccessView.loadXib()
    
    private var statePrenium: FullAccessView.Prenium = .week
    @VariableReplay private var stateView: StateView = .amazing
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ChargeManage.shared.eventPauseAVPlayer = ()
    }
}
extension IntroduceAppVC {
    
    private func setupUI() {
        self.playVideo()
        self.btContinue.applyGradient(withColours: [Asset._0090Ff.color, Asset._00D3Ff.color], gradientOrientation: .horizontal)
        
        self.view.addSubview(vAmazing)
        vAmazing.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.btContinue.snp.top)
        }
        
        self.fullAccess.isHidden = true
        self.view.addSubview(self.fullAccess)
        self.fullAccess.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.btContinue.snp.top)
        }
        self.fullAccess.tapStatePrenium = { stt in
            self.statePrenium = stt
        }
        
        self.view.bringSubviewToFront(self.btBack)
        self.btBack.isHidden = (self.stataBack == .inApp) ? true : false
        
        self.bottomView.constant = self.view.safeAreaBottom
        
        SHARE_APPLICATION_DELEGATE.inappManager.requestProducts { isSuccess, skProducts in
            var list: [InAppVC.SKProductModel] = []
            if isSuccess, let sk = skProducts, sk.count > 0 {
                sk.forEach { item in
                    guard let type = ProductID(rawValue: item.productIdentifier) else { return }
                    let m = InAppVC.SKProductModel(productID: type, price: item.price)
                    list.append(m)
                }
            }
            let listR = (list.count > 0) ? list : ChargeManage.shared.listRawSKProduct()
            self.fullAccess.loadSKProduct(list: listR)
            
            
        }
        SHARE_APPLICATION_DELEGATE.inappManager.completionHandler = { isSuccess, skProducts in
            var list: [InAppVC.SKProductModel] = []
            if isSuccess, let sk = skProducts, sk.count > 0 {
                sk.forEach { item in
                    guard let type = ProductID(rawValue: item.productIdentifier) else { return }
                    let m = InAppVC.SKProductModel(productID: type, price: item.price)
                    list.append(m)
                }
            }
            let listR = (list.count > 0) ? list : ChargeManage.shared.listRawSKProduct()
            self.fullAccess.loadSKProduct(list: listR)
        }
    }
    
    

    private func setupRX() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: weakify({ (_, wSelf) in
                wSelf.animationButton()
            })).disposed(by: disposeBag)
        
        self.btContinue2.rx.tap.bind { _ in
            
            switch self.stateView {
            
            case .amazing:
                self.stateView = .choosen
                self.vAmazing.moveView()
                
            case .choosen:
                self.stateView = .fullAccess
                self.vAmazing.isHidden = true
                self.fullAccess.isHidden = false
                
            case .fullAccess:
                LoadingManager.instance.show()
                switch self.statePrenium {
                case .week:
                    self.weekly()
                case .month:
                    self.monthly()
                case .year:
                    self.yearly()
                }
//                let vc = BaseTabbarViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }.disposed(by: disposeBag)
        
        self.fullAccess.$status.bind(onNext: weakify({ stt, wSelf in
            wSelf.vBottom.backgroundColor = (stt == .hide) ? UIColor.clear : Asset._0D043A.color
        })).disposed(by: disposeBag)
        
        ActionBottom.allCases.forEach { (type) in
            let bt = self.bts[type.rawValue]
            
            bt.rx.tap.bind { _ in
                switch type {
                case .privacy:
                    guard let url = URL(string: LINK_PRICAVY) else { return }
                    UIApplication.shared.open(url)
                case .restore: self.restoreInApp()
                case .term:
                    guard let url = URL(string: LINK_TERM) else { return }
                    UIApplication.shared.open(url)
                }
            }.disposed(by: disposeBag)
        }
        
        self.btBack.rx.tap.bind { _ in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func animationButton() {
        UIView.animate(withDuration: 0.6,
            animations: {
                self.btContinue.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
            completion: { complete in
                if complete {
                    UIView.animate(withDuration: 0.6) {
                        self.btContinue.transform = CGAffineTransform.identity
                    }

                }
            })
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "iphoneX", ofType:"mp4")else {
            debugPrint("video.m4v not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ChargeManage.shared.playAnimation(view: self.vAnimation, url: url, avplayerfrom: .introduce)
        }
    }
    
}
extension IntroduceAppVC {
    
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
                        SHARE_APPLICATION_DELEGATE.setupFlowApp()
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
