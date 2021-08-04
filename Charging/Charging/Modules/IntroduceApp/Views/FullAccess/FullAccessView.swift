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
    
    enum Prenium: Int, CaseIterable {
        case week, month, year
    }
    
    var tapStatePrenium: ((Prenium) -> Void)?

    @IBOutlet weak var btShowOptions: UIButton!
    @IBOutlet weak var stackWeek: UIStackView!
    @IBOutlet weak var bottomPrenium: NSLayoutConstraint!
    @IBOutlet weak var stackViewPrenium: UIStackView!
    @IBOutlet weak var imageDropdown: UIImageView!
    @IBOutlet weak var lbMore: UILabel!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet var views: [UIView]!
    
    @VariableReplay private var statePrenium: Prenium = .week
    @VariableReplay var status: StatusView = .hide
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
                self.backgroundColor = Asset._0D043A.color
            case .hide:
                self.hide()
                self.backgroundColor = UIColor.clear
            }
        }.disposed(by: disposeBag)
        
        self.$statePrenium.asObservable().bind { state in
            
            self.views.enumerated().forEach { item in
                item.element.layer.borderColor = (item.offset == state.rawValue) ? UIColor.white.cgColor : UIColor.clear.cgColor
                item.element.backgroundColor = (item.offset == state.rawValue) ? UIColor.clear : Asset._3B3070.color
            }
            
        }.disposed(by: disposeBag)
        
        Prenium.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            
            bt.rx.tap.bind { _ in
                self.statePrenium = type
                self.tapStatePrenium?(type)
            }.disposed(by: disposeBag)
            
        }
        
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
