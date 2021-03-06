//
//  ABBorder.swift
//  selfband
//
//

import UIKit

class ABBorder: UIView {

    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let bundle = Bundle(for: ABStartIndicator.self)
//        let image = UIImage(named: "BorderLine", in: bundle, compatibleWith: nil)
        
//        imageView.frame = self.bounds
//        imageView.image = image
//        imageView.contentMode = UIView.ContentMode.scaleToFill
//        self.addSubview(imageView)
        
        if #available(iOS 11.0, *) {
            self.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.6274509804, blue: 1, alpha: 1)
        } else {
            self.backgroundColor = .red
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }

}
