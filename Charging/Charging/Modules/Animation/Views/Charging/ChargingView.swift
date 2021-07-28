//
//  ChargingView.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import UIKit
import RxSwift

class ChargingView: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    @IBOutlet weak var lbCharging: UILabel!
    @IBOutlet weak var viewAnimation: UIView!
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
}
extension ChargingView: Weakifiable {
    
    func setupDisplay(item: [ChargingAnimationModel]?) {
        guard let item = item else {
            return
        }
    }
    
    private func setupUI() {
        
    }
    
    private func setupRX() {
        ChargeManage.shared.$eventBatteryLevel.bind { [weak self] value in
            guard let wSelf = self, let value = value else { return }
            wSelf.lbCharging.text = value.batterCharging
        }.disposed(by: disposeBag)
        
    }
    
    func playAnimation() {
        
        if let url = "VideoEffect".getURLLocal(extensionMovie: .mp4) {
            ChargeManage.shared.playAnimation(view: self.viewAnimation,
                                              url: url,
                                              avplayerfrom: .animation)
        }
    }
}
