//
//  HeaderSetting.swift
//  Charging
//
//  Created by haiphan on 30/07/2021.
//

import UIKit

class HeaderSetting: UIView {
    
    
    var actionPrenium: (() -> Void)?
    
    @IBOutlet weak var btPrenium: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }

    @IBAction func actionPrenium(_ sender: UIButton) {
        self.actionPrenium?()
    }
}
extension HeaderSetting {
    
    private func setupUI() {
        
    }
    
}
