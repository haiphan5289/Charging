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
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet var lbs: [UILabel]!
    @IBOutlet weak var lbJust: UILabel!
    
    
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
            self.lbSub.isHidden = false
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
            self.lbSub.isHidden = true
            self.layoutIfNeeded()
        }) { s in
            if s {
            }
        }
    }
    
    func loadSKProduct(list: [InAppVC.SKProductModel]) {
        guard list.count > 0 else {
            return
        }
        
        Prenium.allCases.forEach { type in
            let lb = self.lbs[type.rawValue]
            
            list.forEach { item in
                if item.productID.valuePrenium == type {
                    DispatchQueue.main.async {
                        lb.text = item.price.converString(produceID: item.productID)
                    }
                }
                
                if item.productID.valuePrenium == Prenium.week {
                    DispatchQueue.main.async {
                        self.lbJust.text = "Just \(item.price.converString(produceID: item.productID))"
                    }
                    
                }
            }
            
        }
        
    }
    
    func hideViewMore() {
        self.stackWeek.isHidden = true
        self.viewMore.isHidden = true
        self.stackViewPrenium.isHidden = false
        self.lbSub.isHidden = false
        self.bottomPrenium.constant = 50
    }
    
}
