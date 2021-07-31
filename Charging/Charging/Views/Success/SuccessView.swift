//
//  SuccessView.swift
//  Charging
//
//  Created by haiphan on 31/07/2021.
//

import UIKit

class SuccessView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func addView(parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(200)
            make.height.width.equalTo(100)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.removeView()
        }

    }
    
    private func removeView() {
        self.removeFromSuperview()
    }

}
