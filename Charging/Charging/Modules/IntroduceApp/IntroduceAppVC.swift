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
        case amazing, choosen
    }
    
    @IBOutlet weak var vAnimation: UIView!
    @IBOutlet weak var btContinue: UIButton!
    private let vAmazing: AmazingView = AmazingView.loadXib()
    
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
        

    }
    
    private func setupRX() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: weakify({ (_, wSelf) in
//                wSelf.animationButton()
            })).disposed(by: disposeBag)
        
        self.btContinue.rx.tap.bind { _ in
            
            switch self.stateView {
            
            case .amazing:
                self.stateView = .choosen
                self.vAmazing.moveView()
                
                
            case .choosen: break
            
            }
            
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
            ChargeManage.shared.playAnimation(view: self.vAnimation, url: url, avplayerfrom: .animation)
        }
    }
    
}
