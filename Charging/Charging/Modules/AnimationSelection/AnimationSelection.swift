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

class AnimationSelection: HideNavigationController {
    
    enum StatusAction {
        case show, hide
    }
    
    enum TapAction: Int, CaseIterable {
        case icon, color, sound
    }
    
//    var moviePlayer:AVContro!

    @IBOutlet weak var lbBattery: UILabel!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var hViewBottom: NSLayoutConstraint!
    @IBOutlet weak var vButtons: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btStatus: UIButton!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var imageAnimation: UIImageView!
    
    @VariableReplay private var statusAction: StatusAction = .hide
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
        self.view.layoutIfNeeded()
        ChargeManage.shared.playAnimation(view: self.viewAnimation, link: "iphone8", avplayerfrom: .animationSelection)
    }
    
    
}
extension AnimationSelection {
    
    private func setupUI() {
        self.hViewBottom.constant = self.view.safeAreaBottom
        self.vButtons.clipsToBounds = true
        self.vButtons.layer.cornerRadius = 7
        self.vButtons.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupRX() {
        
        ChargeManage.shared.$eventBatteryLevel.bind(onNext: weakify({ value, wSelf in
            wSelf.lbBattery.text = value?.batterCharging
        })).disposed(by: disposeBag)
        
        TapAction.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            
            bt.rx.tap.bind { _ in
                
                switch type {
                case .icon:
                    let vc = LisiConVC.createVC()
                    guard let setupVC = vc as? LisiConVC else { return }
                    setupVC.modalTransitionStyle = .crossDissolve
                    setupVC.modalPresentationStyle = .overFullScreen
                    self.present(setupVC, animated: true, completion: nil)
                case .color:
                    let vc = ListColorVC.createVC()
                    guard let setupVC = vc as? ListColorVC else { return }
                    setupVC.modalTransitionStyle = .crossDissolve
                    setupVC.modalPresentationStyle = .overFullScreen
                    self.present(setupVC, animated: true, completion: nil)
                case .sound: break
                }
                
            }.disposed(by: disposeBag)
            
        }
        
        self.$statusAction.asObservable().bind(onNext: weakify({ action, wSelf in
            
            let vs = [wSelf.btBack, wSelf.stackView]
            
            switch action {
            case .hide:
                vs.forEach { v in
                    v?.isHidden = true
                }
            case .show:
                vs.forEach { v in
                    v?.isHidden = false
                }
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
    }
    
}
