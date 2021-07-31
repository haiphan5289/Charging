//
//  AmazingView.swift
//  Charging
//
//  Created by haiphan on 31/07/2021.
//

import UIKit

class AmazingView: UIView {
    @IBOutlet weak var stackAmazing: UIStackView!
    @IBOutlet weak var stackChoosen: UIStackView!
    @IBOutlet weak var bottomChoosen: NSLayoutConstraint!
    @IBOutlet weak var bottomAmazing: NSLayoutConstraint!
    
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

}
extension AmazingView {
    
    private func setupUI() {
        
    }
    
    private func setupRX() {
        
    }
    
    func moveView() {
//        UIView.animate(withDuration: 0.3) {
//            var a = self.stackAmazing.frame
//            a.origin.y += 200
//            self.stackAmazing.frame = a
//
//            self.stackChoosen.isHidden = false
//            var b = self.stackChoosen.frame
//            b.origin.y -= 237
//            self.stackChoosen.frame = b
//        } completion: { s in
//            if s {
//                self.stackAmazing.isHidden = true
//
//            }
//        }
//
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn, animations: {
//            var a = self.stackAmazing.frame
//            a.origin.y += 200
//            self.stackAmazing.frame = a
            self.bottomAmazing.constant = 0
            
//            var b = self.stackChoosen.frame
//            b.origin.y -= 237
//            self.stackChoosen.frame = b
            self.bottomChoosen.constant = 37
            self.layoutIfNeeded()
        }) { s in
            if s {
                self.stackChoosen.isHidden = false
                self.stackAmazing.isHidden = true
                
            }
        }


        
    }
    
}
