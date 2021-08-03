//
//  AnimationSelection.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import UIKit
import RxCocoa
import RxSwift
import MediaPlayer
import SVProgressHUD

class AnimationSelection: HideNavigationController {
    
    enum StatusAction {
        case show, hide
    }
    
    enum TapAction: Int, CaseIterable {
        case icon, color, sound
    }
    
    var openfrom: BaseTabbarViewController.openfrom = .home
    
//    var moviePlayer:AVContro!
    var chargingAnimationModel: ChargingAnimationModel?
    var animationIconModel: Video?

    @IBOutlet weak var lbBattery: UILabel!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var hViewBottom: NSLayoutConstraint!
    @IBOutlet weak var vButtons: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btStatus: UIButton!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var imageAnimation: UIImageView!
    @IBOutlet weak var btSetAnimation: UIButton!
    private let viewSuccess: SuccessView = SuccessView.loadXib()
    
    @VariableReplay private var statusAction: StatusAction = .hide
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChargeManage.shared.updateAVPlayerfrom(avplayerfrom: .animationSelection)
//        ChargeManage.shared.eventPlayAVPlayer = ()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ChargeManage.shared.eventPauseAVPlayer = ()
    }
    
    
}
extension AnimationSelection {
    
    private func setupUI() {
        self.hViewBottom.constant = self.view.safeAreaBottom
        self.vButtons.clipsToBounds = true
        self.vButtons.layer.cornerRadius = 7
        self.vButtons.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        switch  self.openfrom {
        case .home:
            if let c = self.animationIconModel, let t = c.filename, let url = URL(string: t) {
                ChargeManage.shared.playAnimation(view: self.viewAnimation, url: url, avplayerfrom: .animationSelection)
            }
        case .app:
            ChargeManage.shared.playVideofromApp(view: self.viewAnimation)
        }
        

        
//        if let c = self.animationIconModel, let t = c.filename, let url = t.getURLLocal(extensionMovie: .mov) {
//            ChargeManage.shared.playAnimation(view: self.viewAnimation, url: url, avplayerfrom: .animationSelection)
//        }
        
//        self.viewButtonSetAnimation.gradientHozorital(color: [Asset._0090Ff.color, Asset._00D3Ff.color])
//        self.view.applyGradient(colours: [.yellow, .blue, .red], locations: [0.0, 0.5, 1.0])
        
        self.btSetAnimation.applyGradient(withColours: [Asset._0090Ff.color, Asset._00D3Ff.color], gradientOrientation: .horizontal)

        
    }
    
    private func setupRX() {
        
        ChargeManage.shared.$loadingModel.asObservable().bind(onNext: weakify({ value, wSelf in
            
            if let v = value, v.current >= v.total {
                LoadingManager.instance.dismiss()
                return
            }
            
            guard let value = value?.getPercent() else { return }
            
            SVProgressHUD.showProgress(Float(value), status: "Loading...\(Double(value).roundTo())%")
            
        })).disposed(by: disposeBag)
        
        ChargeManage.shared.indicator.asObservable().bind(onNext: weakify({ item, wSelf in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        })).disposed(by: disposeBag)
        
        ChargeManage.shared.$eventBatteryLevel.bind(onNext: weakify({ value, wSelf in
            wSelf.lbBattery.text = value?.batterCharging
        })).disposed(by: disposeBag)
        
        TapAction.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            
            bt.rx.tap.bind { _ in
                
                switch type {
                case .icon:
                    let vc = LisiConVC.createVC()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                case .color:
                    let vc = ListColorVC.createVC()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                case .sound: 
                    let vc = ListSoundVC.createVC()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                
            }.disposed(by: disposeBag)
            
        }
        
        self.$statusAction.asObservable().bind(onNext: weakify({ action, wSelf in
            
            switch action {
            case .hide:
                wSelf.btBack.isHidden = false
                wSelf.stackView.isHidden = true
            case .show:
                wSelf.btBack.isHidden = true
                wSelf.stackView.isHidden = false
            }
            
        })).disposed(by: disposeBag)
        
        self.btStatus.rx.tap.bind { _ in
            switch self.statusAction {
            case .hide:
                self.statusAction = .show
            case .show:
                self.statusAction = .hide
            }
        }.disposed(by: disposeBag)
        
        ChargeManage.shared.$colorIndex.bind(onNext: weakify({ v, wSef in
            wSef.lbBattery.textColor = ListColorVC.ColorCell.init(rawValue: v)?.color
        })).disposed(by: disposeBag)
        
        ChargeManage.shared.$iconAnimation.bind(onNext: weakify({ v, wSelf in
            guard let d = v.text else { return }
            wSelf.imageAnimation.image = UIImage(named: d)
        })).disposed(by: disposeBag)
        
        self.btBack.rx.tap.bind { _ in
            switch self.openfrom {
            case .app:
                let vc = BaseTabbarViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default: self.navigationController?.popViewController(animated: true, nil)
            }
            
        }.disposed(by: disposeBag)
        
        self.btSetAnimation.rx.tap.bind { _ in
            guard let v =  self.animationIconModel, let t = v.filename, let url = URL(string: t) else { return }
            do {
                let model = AnimationRealmModel(destinationURL: url)
                let data = try model.toData()
                RealmManage.shared.addAndUpdateAnimation(data: data)
            } catch {
                print("\(error.localizedDescription)")
            }
            
            do {
                self.showSuccessView()
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func showSuccessView() {
        self.viewSuccess.addView(parentView: self.view)
    }
    
}
