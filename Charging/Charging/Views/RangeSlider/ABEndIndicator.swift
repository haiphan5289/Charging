//
//  ABStartIndicator.swift
//  selfband
//
//  Created by Oscar J. Irun on 27/11/16.
//  Copyright © 2016 appsboulevard. All rights reserved.
//

import UIKit

class ABEndIndicator: UIView {
    
    public var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
//        let bundle = Bundle(for: ABStartIndicator.self)
//        let image = UIImage(named: "EndIndicator", in: bundle, compatibleWith: nil)
//
//        imageView.frame = self.bounds
//        imageView.image = image
//        imageView.contentMode = UIView.ContentMode.scaleToFill
//        self.addSubview(imageView)
        
        //background
        let viewCheck: UIView = UIView()
        viewCheck.backgroundColor = .white
        viewCheck.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewCheck)
        if #available(iOS 9.0, *) {
            viewCheck.heightAnchor.constraint(equalToConstant: 20).isActive = true
            viewCheck.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            viewCheck.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            viewCheck.widthAnchor.constraint(equalToConstant: 2).isActive = true
        } else {
            // Fallback on earlier versions
        }

        if #available(iOS 11.0, *) {
            self.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.6274509804, blue: 1, alpha: 1)
        } else {
            self.backgroundColor = .red
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
