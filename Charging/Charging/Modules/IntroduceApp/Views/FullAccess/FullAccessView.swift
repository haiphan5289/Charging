//
//  FullAccessView.swift
//  Charging
//
//  Created by haiphan on 31/07/2021.
//

import UIKit
import RxSwift

class FullAccessView: UIView {
    
    enum StatusView {
        case show, hide
    }

    @IBOutlet weak var btShowOptions: UIButton!
    @IBOutlet weak var stackWeek: UIStackView!
    @IBOutlet weak var bottomPrenium: NSLayoutConstraint!
    @IBOutlet weak var stackViewPrenium: UIStackView!
    @IBOutlet weak var imageDropdown: UIImageView!
    @IBOutlet weak var lbMore: UILabel!
    
    @VariableReplay private var status: StatusView = .hide
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
    
}
extension FullAccessView {
    
    private func setupRX() {
        
        self.btShowOptions.rx.tap.bind { _ in
            
            switch self.status {
            case .hide:
                self.status = .show
//                self.btShowOptions.setTitle("Hide Option", for: .normal)
//                self.btShowOptions.setTitleColor(.white, for: .normal)
                self.lbMore.text = "Hide Option"
                self.imageDropdown.image = Asset.icIntroduceUp.image
            case .show:
                self.status = .hide
//                self.btShowOptions.setTitle("More Option", for: .normal)
                self.lbMore.text = "More Option"
                self.imageDropdown.image = Asset.icIntroduceDown.image
            }
            
        }.disposed(by: disposeBag)
        
        
        self.$status.asObservable().bind { stt in
            
            switch stt {
            case .show:
                self.show()
            case .hide:
                self.hide()
            }
            
        }.disposed(by: disposeBag)
        
    }
    
    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn, animations: {
            self.stackWeek.isHidden = true
            self.bottomPrenium.constant = 50
            self.stackViewPrenium.isHidden = false
            self.layoutIfNeeded()
        }) { s in
            if s {
            }
        }
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn, animations: {
            self.stackWeek.isHidden = false
            self.bottomPrenium.constant = 16
            self.stackViewPrenium.isHidden = true
            self.layoutIfNeeded()
        }) { s in
            if s {
            }
        }
    }
    
}
