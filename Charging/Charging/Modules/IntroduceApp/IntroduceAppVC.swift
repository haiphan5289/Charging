//
//  IntroduceAppVC.swift
//  Charging
//
//  Created by haiphan on 31/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class IntroduceAppVC: UIViewController {

    enum StateView {
        case amazing, choosen, fullAccess
    }
    
    @IBOutlet weak var vAnimation: UIView!
    @IBOutlet weak var btContinue: UIButton!
    @IBOutlet weak var btContinue2: UIButton!
    @IBOutlet weak var vBottom: UIView!
    @IBOutlet weak var bottomViewStack: NSLayoutConstraint!
    @IBOutlet weak var bottomView: NSLayoutConstraint!
    private let vAmazing: AmazingView = AmazingView.loadXib()
    private let fullAccess: FullAccessView = FullAccessView.loadXib()
    
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
        
        self.bottomView.constant = self.view.safeAreaBottom
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
                let vc = BaseTabbarViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }.disposed(by: disposeBag)
        
        self.fullAccess.$status.bind(onNext: weakify({ stt, wSelf in
            wSelf.vBottom.backgroundColor = (stt == .hide) ? UIColor.clear : Asset._0D043A.color
        })).disposed(by: disposeBag)
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
