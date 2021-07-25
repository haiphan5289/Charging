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
    
    func setupDisplay(item: [Banner]?) {
        guard let item = item else {
            return
        }
    }
    
    private func setupUI() {
        
    }
    
    private func setupRX() {
        
    }
}
